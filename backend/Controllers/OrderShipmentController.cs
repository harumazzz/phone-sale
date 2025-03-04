using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/order-shipments")]
    [ApiController]
    public class OrderShipmentController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet("{orderId}")]
        public async Task<ActionResult<IEnumerable<OrderShipment>>> GetOrderShipments(int orderId)
        {
            return await _context.OrderShipments.Where(os => os.OrderId == orderId).Include(os => os.Shipment).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<OrderShipment>> AddOrderShipment(OrderShipment orderShipment)
        {
            _context.OrderShipments.Add(orderShipment);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetOrderShipments), new { orderId = orderShipment.OrderId }, orderShipment);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrderShipment(int id)
        {
            var orderShipment = await _context.OrderShipments.FindAsync(id);
            if (orderShipment == null) return NotFound();
            _context.OrderShipments.Remove(orderShipment);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
