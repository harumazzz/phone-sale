using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/carts")]
    [ApiController]
    public class CartController(PhoneShopContext context) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;        [HttpGet("{customerId}")]
        public async Task<ActionResult<ApiResponse<List<CartResponse>>>> GetCart(string customerId)
        {
            try
            {
                // Validate customerId
                if (string.IsNullOrEmpty(customerId))
                {
                    return HandleBadRequest<List<CartResponse>>("Customer ID cannot be empty");
                }
                
                // Check if customer exists
                var customerExists = await _context.Customers.AnyAsync(c => c.CustomerId == customerId);
                if (!customerExists)
                {
                    return HandleNotFound<List<CartResponse>>("Customer", customerId);
                }
                
                var cartItems = await _context.Carts
                    .Where(c => c.CustomerId == customerId)
                    .Include(c => c.Product)
                    .Select(c => new CartResponse
                    {
                        CartId = c.CartId,
                        CustomerId = c.CustomerId,
                        ProductId = c.ProductId,
                        Quantity = c.Quantity
                    })
                    .ToListAsync();

                return HandleSuccess(cartItems, $"Cart items for customer {customerId} retrieved successfully");
            }
            catch (BadRequestException)
            {
                throw;
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving cart items for customer {customerId}", ex);
            }
        }        [HttpPost]
        public async Task<ActionResult<ApiResponse<CartResponse>>> AddToCart(CartRequest request)
        {
            try
            {
                // Validate request
                if (string.IsNullOrEmpty(request.CustomerId))
                {
                    return HandleBadRequest<CartResponse>("Customer ID cannot be empty");
                }
                
                if (request.Quantity <= 0)
                {
                    return HandleBadRequest<CartResponse>("Quantity must be greater than zero");
                }
                
                // Verify customer exists
                var customer = await _context.Customers.FindAsync(request.CustomerId);
                if (customer == null)
                {
                    return HandleNotFound<CartResponse>("Customer", request.CustomerId);
                }
                
                // Verify product exists
                var product = await _context.Products.FindAsync(request.ProductId);
                if (product == null)
                {
                    return HandleNotFound<CartResponse>("Product", request.ProductId);
                }
                
                // Check if product has enough stock
                if (product.Stock < request.Quantity)
                {
                    return HandleConflict<CartResponse>($"Not enough stock available. Requested: {request.Quantity}, Available: {product.Stock}");
                }

                // Check if item already exists in cart
                var existingCartItem = await _context.Carts
                    .FirstOrDefaultAsync(c => c.CustomerId == request.CustomerId && c.ProductId == request.ProductId);
                    
                if (existingCartItem != null)
                {
                    // Update quantity instead of creating a new item
                    existingCartItem.Quantity += request.Quantity;
                    await _context.SaveChangesAsync();
                    
                    var updatedResponse = new CartResponse
                    {
                        CartId = existingCartItem.CartId,
                        CustomerId = existingCartItem.CustomerId,
                        ProductId = existingCartItem.ProductId,
                        Quantity = existingCartItem.Quantity
                    };
                    
                    return HandleSuccess(updatedResponse, "Item added to cart successfully");
                }
                else
                {
                    // Create new cart item
                    var cartItem = new Cart
                    {
                        CustomerId = request.CustomerId,
                        ProductId = request.ProductId,
                        Quantity = request.Quantity,
                    };
                    
                    _context.Carts.Add(cartItem);
                    await _context.SaveChangesAsync();

                    var response = new CartResponse
                    {
                        CartId = cartItem.CartId,
                        CustomerId = cartItem.CustomerId,
                        ProductId = cartItem.ProductId,
                        Quantity = cartItem.Quantity
                    };
                    
                    return HandleCreated(nameof(GetCart), new { customerId = cartItem.CustomerId }, response, "Item added to cart successfully");
                }
            }
            catch (BadRequestException)
            {
                throw;
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
                throw new Exception("Error adding item to cart", ex);
            }
        }        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> UpdateCartItem(int id, CartRequest request)
        {
            try
            {
                // Find cart item
                var cartItem = await _context.Carts.FindAsync(id);
                if (cartItem == null)
                {
                    return HandleNotFound<object>("Cart item", id);
                }
                
                // Validate request
                if (request.Quantity <= 0)
                {
                    return HandleBadRequest<object>("Quantity must be greater than zero");
                }
                
                // Verify product exists
                var product = await _context.Products.FindAsync(request.ProductId);
                if (product == null)
                {
                    return HandleNotFound<object>("Product", request.ProductId);
                }
                
                // Check if product has enough stock
                if (product.Stock < request.Quantity)
                {
                    return HandleConflict<object>($"Not enough stock available. Requested: {request.Quantity}, Available: {product.Stock}");
                }
                
                cartItem.Quantity = request.Quantity;
                await _context.SaveChangesAsync();
                return HandleSuccess($"Cart item with ID {id} updated successfully");
            }
            catch (BadRequestException)
            {
                throw;
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
                throw new Exception($"Error updating cart item with ID {id}", ex);
            }
        }        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> RemoveFromCart(int id)
        {
            try
            {
                var cartItem = await _context.Carts.FindAsync(id);
                if (cartItem == null)
                {
                    return HandleNotFound<object>("Cart item", id);
                }

                _context.Carts.Remove(cartItem);
                await _context.SaveChangesAsync();

                return HandleSuccess($"Cart item with ID {id} removed successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error removing cart item with ID {id}", ex);
            }
        }
    }

}
