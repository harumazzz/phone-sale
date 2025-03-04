using backend.Data;
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
        public async Task<ActionResult<IEnumerable<Cart>>> GetCart(int customerId)
        {
            return await _context.Carts.Where(c => c.CustomerId == customerId).Include(c => c.Product).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<Cart>> AddToCart(Cart cart)
        {
            _context.Carts.Add(cart);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetCart), new { customerId = cart.CustomerId }, cart);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCartItem(int id, Cart cart)
        {
            if (id != cart.CartId) return BadRequest();
            _context.Entry(cart).State = EntityState.Modified;
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
