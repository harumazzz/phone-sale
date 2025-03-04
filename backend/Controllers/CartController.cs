using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/carts")]
    [ApiController]
    public class CartController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet("{customerId}")]
        public async Task<ActionResult<IEnumerable<CartResponse>>> GetCart(int customerId)
        {
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

            return Ok(cartItems);
        }

        [HttpPost]
        public async Task<ActionResult<CartResponse>> AddToCart(CartRequest request)
        {
            var product = await _context.Products.FindAsync(request.ProductId);
            if (product == null) return NotFound("Product not found");

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
            return CreatedAtAction(nameof(GetCart), new { customerId = cartItem.CustomerId }, response);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCartItem(int id, CartRequest request)
        {
            var cartItem = await _context.Carts.FindAsync(id);
            if (cartItem == null) return NotFound();
            cartItem.Quantity = request.Quantity;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> RemoveFromCart(int id)
        {
            var cartItem = await _context.Carts.FindAsync(id);
            if (cartItem == null) return NotFound();

            _context.Carts.Remove(cartItem);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }

}
