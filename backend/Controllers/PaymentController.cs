using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/payments")]
    [ApiController]
    public class PaymentController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet]
        public async Task<ActionResult<IEnumerable<PaymentResponse>>> GetPayments()
        {
            var payments = await _context.Payments.ToListAsync();
            var responseList = payments.Select(p => new PaymentResponse
            {
                PaymentId = p.PaymentId,
                PaymentDate = p.PaymentDate,
                PaymentMethod = p.PaymentMethod,
                Amount = p.Amount,
                CustomerId = p.CustomerId
            }).ToList();

            return Ok(responseList);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<PaymentResponse>> GetPayment(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null) return NotFound();

            var response = new PaymentResponse
            {
                PaymentId = payment.PaymentId,
                PaymentDate = payment.PaymentDate,
                PaymentMethod = payment.PaymentMethod,
                Amount = payment.Amount,
                CustomerId = payment.CustomerId
            };

            return Ok(response);
        }

        [HttpPost]
        public async Task<ActionResult<PaymentResponse>> CreatePayment(PaymentRequest paymentDto)
        {
            var payment = new Payment
            {
                PaymentDate = DateTime.Now,
                PaymentMethod = paymentDto.PaymentMethod,
                Amount = paymentDto.Amount,
                CustomerId = paymentDto.CustomerId
            };

            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            var response = new PaymentResponse
            {
                PaymentId = payment.PaymentId,
                PaymentDate = payment.PaymentDate,
                PaymentMethod = payment.PaymentMethod,
                Amount = payment.Amount,
                CustomerId = payment.CustomerId
            };

            return CreatedAtAction(nameof(GetPayment), new { id = payment.PaymentId }, response);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePayment(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null) return NotFound();

            _context.Payments.Remove(payment);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}