using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/shipments")]
    [ApiController]
    public class ShipmentController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Shipment>>> GetShipments()
        {
            return await _context.Shipments.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Shipment>> GetShipment(int id)
        {
            var shipment = await _context.Shipments.FindAsync(id);
            if (shipment == null) return NotFound();
            return shipment;
        }

        [HttpPost]
        public async Task<ActionResult<Shipment>> CreateShipment(Shipment shipment)
        {
            _context.Shipments.Add(shipment);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetShipment), new { id = shipment.ShipmentId }, shipment);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShipment(int id)
        {
            var shipment = await _context.Shipments.FindAsync(id);
            if (shipment == null) return NotFound();
            _context.Shipments.Remove(shipment);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
