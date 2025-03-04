using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using backend.DTO.Request;

namespace backend.Controllers
{
    [Route("api/auth")]
    [ApiController]
    public class AuthController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpPost("register")]
        public async Task<ActionResult<string?>> Register(Customer customer)
        {
            var existingCustomer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == customer.Email);
            if (existingCustomer != null)
            {
                return BadRequest("Email is already in use.");
            }
            _context.Customers.Add(customer);
            await _context.SaveChangesAsync();
            return Ok();
        }

        [HttpPost("login")]
        public async Task<ActionResult<Customer>> Login([FromBody] LoginRequest request)
        {
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == request.Email && c.Password == request.Password);
            if (customer == null)
            {
                return Unauthorized("Invalid email or password.");
            }
            return Ok(customer);
        }
    }

}
