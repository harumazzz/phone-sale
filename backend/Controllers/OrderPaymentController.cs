using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
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
        public async Task<ActionResult<IEnumerable<OrderPaymentResponse>>> GetOrderPayments(int orderId)
        {
            var orderPayments = await _context.OrderPayments
                .Where(op => op.OrderId == orderId)
                .Include(op => op.Payment)
                .Select(op => new OrderPaymentResponse
                {
                    OrderId = op.OrderId,
                    PaymentId = op.PaymentId
                })
                .ToListAsync();

            return Ok(orderPayments);
        }

        [HttpGet("item/{orderId}/{paymentId}")]
        public async Task<ActionResult<OrderPaymentResponse>> GetOrderPayment(int orderId, int paymentId)
        {
            var orderPayment = await _context.OrderPayments
                .Include(op => op.Payment)
                .FirstOrDefaultAsync(op => op.OrderId == orderId && op.PaymentId == paymentId);

            if (orderPayment == null) return NotFound();

            var response = new OrderPaymentResponse
            {
                OrderId = orderPayment.OrderId,
                PaymentId = orderPayment.PaymentId,
            };

            return Ok(response);
        }

        [HttpPost]
        public async Task<ActionResult<OrderPaymentResponse>> AddOrderPayment(OrderPaymentRequest request)
        {
            var order = await _context.Orders.FindAsync(request.OrderId);
            if (order == null) return BadRequest("Invalid Order ID");

            var payment = await _context.Payments.FindAsync(request.PaymentId);
            if (payment == null) return BadRequest("Invalid Payment ID");

            var orderPayment = new OrderPayment
            {
                OrderId = request.OrderId,
                PaymentId = request.PaymentId
            };

            _context.OrderPayments.Add(orderPayment);
            await _context.SaveChangesAsync();

            var response = new OrderPaymentResponse
            {
                OrderId = orderPayment.OrderId,
                PaymentId = orderPayment.PaymentId,
            };

            return CreatedAtAction(nameof(GetOrderPayment), new { orderId = orderPayment.OrderId, paymentId = orderPayment.PaymentId }, response);
        }

        [HttpPut("{orderId}/{paymentId}")]
        public async Task<IActionResult> UpdateOrderPayment(int orderId, int paymentId, OrderPaymentRequest request)
        {
            var orderPayment = await _context.OrderPayments.FirstOrDefaultAsync(op => op.OrderId == orderId && op.PaymentId == paymentId);
            if (orderPayment == null) return NotFound();

            var order = await _context.Orders.FindAsync(request.OrderId);
            if (order == null) return BadRequest("Invalid Order ID");

            var payment = await _context.Payments.FindAsync(request.PaymentId);
            if (payment == null) return BadRequest("Invalid Payment ID");

            orderPayment.OrderId = request.OrderId;
            orderPayment.PaymentId = request.PaymentId;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{orderId}/{paymentId}")]
        public async Task<IActionResult> DeleteOrderPayment(int orderId, int paymentId)
        {
            var orderPayment = await _context.OrderPayments.FirstOrDefaultAsync(op => op.OrderId == orderId && op.PaymentId == paymentId);
            if (orderPayment == null) return NotFound();

            _context.OrderPayments.Remove(orderPayment);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
