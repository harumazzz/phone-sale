using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
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
        public async Task<ActionResult<IEnumerable<WishlistResponse>>> GetWishlist(string customerId)
        {
            var wishlists = await _context.Wishlists.Where(w => w.CustomerId == customerId).ToListAsync();
            return Ok(wishlists.Select(w => new WishlistResponse
            {
                CustomerId = w.CustomerId,
                ProductId = w.ProductId,
                WishlistId = w.WishlistId,
            }));
        }

        [HttpPost]
        public async Task<ActionResult<WishlistResponse>> AddToWishlist(WishlistRequest wishlistDto)
        {
            var wishlist = new Wishlist
            {
                CustomerId = wishlistDto.CustomerId,
                ProductId = wishlistDto.ProductId,
            };
            _context.Wishlists.Add(wishlist);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetWishlist), new { customerId = wishlist.CustomerId }, new WishlistResponse
            {
                CustomerId = wishlist.CustomerId,
                ProductId = wishlist.ProductId,
                WishlistId = wishlist.WishlistId,
            });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateWishlist(int id, WishlistRequest wishlistDto)
        {
            var wishlist = await _context.Wishlists.FindAsync(id);
            if (wishlist == null) return NotFound();
            wishlist.CustomerId = wishlistDto.CustomerId;
            wishlist.ProductId = wishlistDto.ProductId;
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
