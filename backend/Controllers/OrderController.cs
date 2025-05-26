using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/orders")]
    [ApiController]
    public class OrderController(PhoneShopContext context) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<OrderResponse>>>> GetOrders()
        {
            try
            {                var orders = await _context.Orders
                    .Include(o => o.Customer)
                    .Include(o => o.Discount)
                    .Select(o => new OrderResponse
                    {
                        OrderId = o.OrderId,
                        OrderDate = o.OrderDate,
                        TotalPrice = o.TotalPrice,
                        OriginalPrice = o.OriginalPrice,
                        DiscountAmount = o.DiscountAmount,
                        DiscountId = o.DiscountId,
                        DiscountCode = o.Discount != null ? o.Discount.Code : null,
                        CustomerId = o.CustomerId,
                        Status = o.Status
                    })
                    .ToListAsync();

                return HandleSuccess(orders, "Orders retrieved successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving orders", ex);
            }
        }        [HttpGet("/api/orders/customer/{id}")]
        public async Task<ActionResult<ApiResponse<List<OrderResponse>>>> GetOrdersByCustomerId(string id)
        {
            try
            {
                // Verify customer exists
                var customer = await _context.Customers.FindAsync(id);
                if (customer == null)
                {
                    return HandleNotFound<List<OrderResponse>>("Customer", id);
                }
                  var orders = await _context.Orders
                    .Where(e => e.CustomerId == id)
                    .Include(o => o.Customer)
                    .Include(o => o.Discount)
                    .Select(o => new OrderResponse
                    {
                        OrderId = o.OrderId,
                        OrderDate = o.OrderDate,
                        TotalPrice = o.TotalPrice,
                        OriginalPrice = o.OriginalPrice,
                        DiscountAmount = o.DiscountAmount,
                        DiscountId = o.DiscountId,
                        DiscountCode = o.Discount != null ? o.Discount.Code : null,
                        CustomerId = o.CustomerId,
                        Status = o.Status
                    })
                    .ToListAsync();

                return HandleSuccess(orders, $"Orders for customer {id} retrieved successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving orders for customer {id}", ex);
            }
        }        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<OrderResponse>>> GetOrder(int id)
        {
            try
            {                var order = await _context.Orders
                    .Include(o => o.Customer)
                    .Include(o => o.Discount)
                    .FirstOrDefaultAsync(o => o.OrderId == id);

                if (order == null)
                {
                    return HandleNotFound<OrderResponse>("Order", id);
                }

                var response = new OrderResponse
                {
                    OrderId = order.OrderId,
                    OrderDate = order.OrderDate,
                    TotalPrice = order.TotalPrice,
                    OriginalPrice = order.OriginalPrice,
                    DiscountAmount = order.DiscountAmount,
                    DiscountId = order.DiscountId,
                    DiscountCode = order.Discount?.Code,
                    CustomerId = order.CustomerId,
                    Status = order.Status
                };

                return HandleSuccess(response, $"Order with ID {id} retrieved successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving order with ID {id}", ex);
            }
        }        [HttpPost]
        public async Task<ActionResult<ApiResponse<OrderResponse>>> CreateOrder(OrderRequest request)
        {
            try
            {
                // Validate request
                if (string.IsNullOrEmpty(request.CustomerId))
                {
                    return HandleBadRequest<OrderResponse>("Customer ID is required");
                }
                
                if (request.TotalPrice < 0)
                {
                    return HandleBadRequest<OrderResponse>("Total price cannot be negative");
                }
                
                var customer = await _context.Customers.FindAsync(request.CustomerId);
                if (customer == null)
                {
                    return HandleBadRequest<OrderResponse>($"Invalid Customer ID: {request.CustomerId}");
                }                var order = new Order
                {
                    OrderDate = DateTime.Now,
                    TotalPrice = request.TotalPrice,
                    OriginalPrice = request.OriginalPrice > 0 ? request.OriginalPrice : request.TotalPrice,
                    DiscountAmount = request.DiscountAmount,
                    DiscountId = request.DiscountId,
                    CustomerId = request.CustomerId,
                    Customer = customer,
                    Status = request.Status ?? OrderStatus.Pending
                };
                
                // If a discount is used, increment its usage count
                if (request.DiscountId.HasValue)
                {
                    var discount = await _context.Discounts.FindAsync(request.DiscountId.Value);
                    if (discount != null)
                    {
                        discount.CurrentUses++;
                        _context.Discounts.Update(discount);
                    }
                }
                
                _context.Orders.Add(order);
                await _context.SaveChangesAsync();

                string? discountCode = null;
                if (order.DiscountId.HasValue)
                {
                    var discount = await _context.Discounts.FindAsync(order.DiscountId.Value);
                    discountCode = discount?.Code;
                }

                var response = new OrderResponse
                {
                    OrderId = order.OrderId,
                    OrderDate = order.OrderDate,
                    TotalPrice = order.TotalPrice,
                    OriginalPrice = order.OriginalPrice,
                    DiscountAmount = order.DiscountAmount,
                    DiscountId = order.DiscountId,
                    DiscountCode = discountCode,
                    CustomerId = order.CustomerId,
                    Status = order.Status
                };
                
                return HandleCreated(nameof(GetOrder), new { id = order.OrderId }, response, "Order created successfully");
            }
            catch (BadRequestException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception("Error creating order", ex);
            }
        }        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> UpdateOrder(int id, OrderRequest request)
        {
            try
            {
                var order = await _context.Orders.FindAsync(id);
                if (order == null)
                {
                    return HandleNotFound<object>("Order", id);
                }

                // Validate customer ID
                if (string.IsNullOrEmpty(request.CustomerId))
                {
                    return HandleBadRequest<object>("Customer ID is required");
                }
                
                if (request.TotalPrice < 0)
                {
                    return HandleBadRequest<object>("Total price cannot be negative");
                }

                var customer = await _context.Customers.FindAsync(request.CustomerId);
                if (customer == null)
                {
                    return HandleBadRequest<object>($"Invalid Customer ID: {request.CustomerId}");
                }

                order.TotalPrice = request.TotalPrice;
                order.CustomerId = request.CustomerId;
                order.Customer = customer;
                
                // Update status if provided
                if (request.Status.HasValue)
                {
                    order.Status = request.Status.Value;
                }

                await _context.SaveChangesAsync();
                return HandleSuccess($"Order with ID {id} updated successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (BadRequestException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating order with ID {id}", ex);
            }
        }        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteOrder(int id)
        {
            try
            {
                var order = await _context.Orders.FindAsync(id);
                if (order == null)
                {
                    return HandleNotFound<object>("Order", id);
                }
                
                // Check if order has order items before deletion
                var hasOrderItems = await _context.OrderItems.AnyAsync(oi => oi.OrderId == id);
                if (hasOrderItems)
                {
                    return HandleConflict<object>($"Cannot delete order with ID {id} as it has related order items. Remove the order items first.");
                }
                
                // Check if order has payments before deletion
                var hasPayments = await _context.OrderPayments.AnyAsync(op => op.OrderId == id);
                if (hasPayments)
                {
                    return HandleConflict<object>($"Cannot delete order with ID {id} as it has related payments. Remove the payments first.");
                }
                
                // Check if order has shipments before deletion
                var hasShipments = await _context.OrderShipments.AnyAsync(os => os.OrderId == id);
                if (hasShipments)
                {
                    return HandleConflict<object>($"Cannot delete order with ID {id} as it has related shipments. Remove the shipments first.");
                }

                _context.Orders.Remove(order);
                await _context.SaveChangesAsync();
                return HandleSuccess($"Order with ID {id} deleted successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (ConflictException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error deleting order with ID {id}", ex);
            }
        }
    }
}
