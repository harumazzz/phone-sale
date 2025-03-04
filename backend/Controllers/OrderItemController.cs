using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/order-items")]
    [ApiController]
    public class OrderItemController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet("{orderId}")]
        public async Task<ActionResult<IEnumerable<OrderItem>>> GetOrderItems(int orderId)
        {
            return await _context.OrderItems.Where(oi => oi.OrderId == orderId).Include(oi => oi.Product).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<OrderItem>> AddOrderItem(OrderItem orderItem)
        {
            _context.OrderItems.Add(orderItem);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetOrderItems), new { orderId = orderItem.OrderId }, orderItem);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrderItem(int id)
        {
            var orderItem = await _context.OrderItems.FindAsync(id);
            if (orderItem == null) return NotFound();
            _context.OrderItems.Remove(orderItem);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
