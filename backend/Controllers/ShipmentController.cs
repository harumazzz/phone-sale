using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics.Metrics;
using System.Net;
using System.Reflection.Emit;

namespace backend.Controllers
{
    [Route("api/shipments")]
    [ApiController]
    public class ShipmentController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ShipmentResponse>>> GetShipments()
        {
            var shipments = await _context.Shipments.ToListAsync();
            return Ok(shipments.Select(s => new ShipmentResponse
            {
                Address = s.Address,
                City = s.City,
                Country = s.Country,
                CustomerId = s.CustomerId,
                ShipmentDate = s.ShipmentDate,
                ShipmentId = s.ShipmentId,
                State = s.State,
                ZipCode = s.ZipCode,
            }));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ShipmentResponse>> GetShipment(int id)
        {
            var shipment = await _context.Shipments.FindAsync(id);
            if (shipment == null) return NotFound();
            return Ok(new ShipmentResponse {
                Address = shipment.Address,
                City = shipment.City,
                Country = shipment.Country,
                CustomerId = shipment.CustomerId,
                ShipmentDate = shipment.ShipmentDate,
                ShipmentId = shipment.ShipmentId,
                State = shipment.State,
                ZipCode = shipment.ZipCode,
            });
        }

        [HttpPost]
        public async Task<ActionResult<ShipmentResponse>> CreateShipment(ShipmentRequest shipmentDto)
        {
            var shipment = new Shipment {
                Address = shipmentDto.Address,
                City = shipmentDto.City,
                Country = shipmentDto.Country,
                CustomerId = shipmentDto.CustomerId,
                ShipmentDate = shipmentDto.ShipmentDate,
                State = shipmentDto.State,
                ZipCode = shipmentDto.ZipCode,
            };
            _context.Shipments.Add(shipment);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetShipment), new { id = shipment.ShipmentId }, new ShipmentResponse
            {
                Address = shipment.Address,
                City = shipment.City,
                Country = shipment.Country,
                CustomerId = shipment.CustomerId,
                ShipmentDate = shipment.ShipmentDate,
                ShipmentId = shipment.ShipmentId,
                State = shipment.State,
                ZipCode = shipment.ZipCode,
            });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateShipment(int id, ShipmentRequest shipmentDto)
        {
            var shipment = await _context.Shipments.FindAsync(id);
            if (shipment == null) return NotFound();
            shipment.Address = shipmentDto.Address;
            shipment.City = shipmentDto.City;
            shipment.Country = shipmentDto.Country;
            shipment.CustomerId = shipmentDto.CustomerId;
            shipment.ShipmentDate = shipmentDto.ShipmentDate;
            shipment.State = shipmentDto.State;
            shipment.ZipCode = shipmentDto.ZipCode;
            await _context.SaveChangesAsync();
            return NoContent();
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
