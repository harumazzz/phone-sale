using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/orders")]
    [ApiController]
    public class OrderController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrderResponse>>> GetOrders()
        {
            var orders = await _context.Orders
                .Include(o => o.Customer)
                .Select(o => new OrderResponse
                {
                    OrderId = o.OrderId,
                    OrderDate = o.OrderDate,
                    TotalPrice = o.TotalPrice,
                    CustomerId = o.CustomerId,
                    Status = o.Status
                })
                .ToListAsync();

            return Ok(orders);
        }

        [HttpGet("/api/orders/customer/{id}")]
        public async Task<ActionResult<IEnumerable<OrderResponse>>> GetOrdersByCustomerId(string id)
        {
            var orders = await _context.Orders
                .Where(e => e.CustomerId == id)
                .Include(o => o.Customer)
                .Select(o => new OrderResponse
                {
                    OrderId = o.OrderId,
                    OrderDate = o.OrderDate,
                    TotalPrice = o.TotalPrice,
                    CustomerId = o.CustomerId,
                    Status = o.Status
                })
                .ToListAsync();

            return Ok(orders);
        }        [HttpGet("{id}")]
        public async Task<ActionResult<OrderResponse>> GetOrder(int id)
        {
            var order = await _context.Orders
                .Include(o => o.Customer)
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null) return NotFound();

            var response = new OrderResponse
            {
                OrderId = order.OrderId,
                OrderDate = order.OrderDate,
                TotalPrice = order.TotalPrice,
                CustomerId = order.CustomerId,
                Status = order.Status
            };

            return Ok(response);
        }

        [HttpPost]
        public async Task<ActionResult<OrderResponse>> CreateOrder(OrderRequest request)
        {
            var customer = await _context.Customers.FindAsync(request.CustomerId);
            if (customer == null) return BadRequest("Invalid Customer ID");

            var order = new Order
            {
                OrderDate = DateTime.Now,
                TotalPrice = request.TotalPrice,
                CustomerId = request.CustomerId,
                Customer = customer,
                Status = request.Status ?? OrderStatus.Pending
            };            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            var response = new OrderResponse
            {
                OrderId = order.OrderId,
                OrderDate = order.OrderDate,
                TotalPrice = order.TotalPrice,
                CustomerId = order.CustomerId,
                Status = order.Status
            };
            return CreatedAtAction(nameof(GetOrder), new { id = order.OrderId }, response);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateOrder(int id, OrderRequest request)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order == null) return NotFound();

            var customer = await _context.Customers.FindAsync(request.CustomerId);
            if (customer == null) return BadRequest("Invalid Customer ID");

            order.TotalPrice = request.TotalPrice;
            order.CustomerId = request.CustomerId;
            order.Customer = customer;
            
            // Update status if provided
            if (request.Status.HasValue)
            {
                order.Status = request.Status.Value;
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrder(int id)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order == null) return NotFound();

            _context.Orders.Remove(order);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
