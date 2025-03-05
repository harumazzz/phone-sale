using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
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
        public async Task<ActionResult<IEnumerable<OrderItemResponse>>> GetOrderItems(int orderId)
        {
            var orderItems = await _context.OrderItems
                .Where(oi => oi.OrderId == orderId)
                .Include(oi => oi.Product)
                .Select(oi => new OrderItemResponse
                {
                    OrderItemId = oi.OrderItemId,
                    Quantity = oi.Quantity,
                    Price = oi.Price,
                    OrderId = oi.OrderId,
                    ProductId = oi.ProductId,
                })
                .ToListAsync();

            return Ok(orderItems);
        }

        [HttpGet("item/{id}")]
        public async Task<ActionResult<OrderItemResponse>> GetOrderItem(int id)
        {
            var orderItem = await _context.OrderItems
                .Include(oi => oi.Product)
                .FirstOrDefaultAsync(oi => oi.OrderItemId == id);

            if (orderItem == null) return NotFound();

            var response = new OrderItemResponse
            {
                OrderItemId = orderItem.OrderItemId,
                Quantity = orderItem.Quantity,
                Price = orderItem.Price,
                OrderId = orderItem.OrderId,
                ProductId = orderItem.ProductId,
            };

            return Ok(response);
        }

        [HttpPost]
        public async Task<ActionResult<OrderItemResponse>> AddOrderItem(OrderItemRequest request)
        {
            var order = await _context.Orders.FindAsync(request.OrderId);
            if (order == null) return BadRequest("Invalid Order ID");

            var product = await _context.Products.FindAsync(request.ProductId);
            if (product == null) return BadRequest("Invalid Product ID");

            var orderItem = new OrderItem
            {
                Quantity = request.Quantity,
                Price = request.Price,
                OrderId = request.OrderId,
                ProductId = request.ProductId
            };

            _context.OrderItems.Add(orderItem);
            await _context.SaveChangesAsync();

            var response = new OrderItemResponse
            {
                OrderItemId = orderItem.OrderItemId,
                Quantity = orderItem.Quantity,
                Price = orderItem.Price,
                OrderId = orderItem.OrderId,
                ProductId = orderItem.ProductId,
            };

            return CreatedAtAction(nameof(GetOrderItem), new { id = orderItem.OrderItemId }, response);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateOrderItem(int id, OrderItemRequest request)
        {
            var orderItem = await _context.OrderItems.FindAsync(id);
            if (orderItem == null) return NotFound();

            var order = await _context.Orders.FindAsync(request.OrderId);
            if (order == null) return BadRequest("Invalid Order ID");

            var product = await _context.Products.FindAsync(request.ProductId);
            if (product == null) return BadRequest("Invalid Product ID");

            orderItem.Quantity = request.Quantity;
            orderItem.Price = request.Price;
            orderItem.OrderId = request.OrderId;
            orderItem.ProductId = request.ProductId;

            await _context.SaveChangesAsync();
            return NoContent();
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
