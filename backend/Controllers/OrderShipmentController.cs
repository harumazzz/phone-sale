using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
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
        public async Task<ActionResult<IEnumerable<OrderShipmentResponse>>> GetOrderShipments(int orderId)
        {
            var orderShipments = await _context.OrderShipments
                .Where(os => os.OrderId == orderId)
                .Include(os => os.Shipment)
                .Select(os => new OrderShipmentResponse
                {
                    OrderId = os.OrderId,
                    ShipmentId = os.ShipmentId,
                })
                .ToListAsync();

            return Ok(orderShipments);
        }

        [HttpGet("item/{orderId}/{shipmentId}")]
        public async Task<ActionResult<OrderShipmentResponse>> GetOrderShipment(int orderId, int shipmentId)
        {
            var orderShipment = await _context.OrderShipments
                .Include(os => os.Shipment)
                .FirstOrDefaultAsync(os => os.OrderId == orderId && os.ShipmentId == shipmentId);

            if (orderShipment == null) return NotFound();

            var response = new OrderShipmentResponse
            {
                OrderId = orderShipment.OrderId,
                ShipmentId = orderShipment.ShipmentId,
            };

            return Ok(response);
        }

        // Add an order shipment
        [HttpPost]
        public async Task<ActionResult<OrderShipmentResponse>> AddOrderShipment(OrderShipmentRequest request)
        {
            var order = await _context.Orders.FindAsync(request.OrderId);
            if (order == null) return BadRequest("Invalid Order ID");

            var shipment = await _context.Shipments.FindAsync(request.ShipmentId);
            if (shipment == null) return BadRequest("Invalid Shipment ID");

            var orderShipment = new OrderShipment
            {
                OrderId = request.OrderId,
                ShipmentId = request.ShipmentId
            };
            _context.OrderShipments.Add(orderShipment);
            await _context.SaveChangesAsync();

            var response = new OrderShipmentResponse
            {
                OrderId = orderShipment.OrderId,
                ShipmentId = orderShipment.ShipmentId,
            };

            return CreatedAtAction(nameof(GetOrderShipment), new { orderId = orderShipment.OrderId, shipmentId = orderShipment.ShipmentId }, response);
        }

        [HttpPut("{orderId}/{shipmentId}")]
        public async Task<IActionResult> UpdateOrderShipment(int orderId, int shipmentId, OrderShipmentRequest request)
        {
            var orderShipment = await _context.OrderShipments.FirstOrDefaultAsync(os => os.OrderId == orderId && os.ShipmentId == shipmentId);
            if (orderShipment == null) return NotFound();

            var order = await _context.Orders.FindAsync(request.OrderId);
            if (order == null) return BadRequest("Invalid Order ID");

            var shipment = await _context.Shipments.FindAsync(request.ShipmentId);
            if (shipment == null) return BadRequest("Invalid Shipment ID");

            orderShipment.OrderId = request.OrderId;
            orderShipment.ShipmentId = request.ShipmentId;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{orderId}/{shipmentId}")]
        public async Task<IActionResult> DeleteOrderShipment(int orderId, int shipmentId)
        {
            var orderShipment = await _context.OrderShipments.FirstOrDefaultAsync(os => os.OrderId == orderId && os.ShipmentId == shipmentId);
            if (orderShipment == null) return NotFound();

            _context.OrderShipments.Remove(orderShipment);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
