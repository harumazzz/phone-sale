using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/wishlist")]
    [ApiController]
    public class WishlistController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet("{customerId}")]
        public async Task<ActionResult<IEnumerable<Wishlist>>> GetWishlist(int customerId)
        {
            return await _context.Wishlists.Where(w => w.CustomerId == customerId).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<Wishlist>> AddToWishlist(Wishlist wishlist)
        {
            _context.Wishlists.Add(wishlist);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetWishlist), new { customerId = wishlist.CustomerId }, wishlist);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateWishlist(int id, Wishlist updatedWishlist)
        {
            if (id != updatedWishlist.WishlistId)
                return BadRequest("Wishlist ID mismatch");

            var existingWishlist = await _context.Wishlists.FindAsync(id);
            if (existingWishlist == null) return NotFound();
            existingWishlist.CustomerId = updatedWishlist.CustomerId;
            existingWishlist.ProductId = updatedWishlist.ProductId;

            _context.Entry(existingWishlist).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> RemoveFromWishlist(int id)
        {
            var wishlist = await _context.Wishlists.FindAsync(id);
            if (wishlist == null) return NotFound();
            _context.Wishlists.Remove(wishlist);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
