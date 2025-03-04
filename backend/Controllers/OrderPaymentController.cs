using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/order-payments")]
    [ApiController]
    public class OrderPaymentController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet("{orderId}")]
        public async Task<ActionResult<IEnumerable<OrderPayment>>> GetOrderPayments(int orderId)
        {
            return await _context.OrderPayments.Where(op => op.OrderId == orderId).Include(op => op.Payment).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<OrderPayment>> AddOrderPayment(OrderPayment orderPayment)
        {
            _context.OrderPayments.Add(orderPayment);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetOrderPayments), new { orderId = orderPayment.OrderId }, orderPayment);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrderPayment(int id)
        {
            var orderPayment = await _context.OrderPayments.FindAsync(id);
            if (orderPayment == null) return NotFound();
            _context.OrderPayments.Remove(orderPayment);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
