using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/customers")]
    [ApiController]
    public class CustomersController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CustomerResponse>>> GetCustomers()
        {
            var customers = await _context.Customers
                .Select(c => new CustomerResponse
                {
                    CustomerId = c.CustomerId,
                    FirstName = c.FirstName,
                    LastName = c.LastName,
                    Email = c.Email,
                    Address = c.Address,
                    PhoneNumber = c.PhoneNumber
                })
                .ToListAsync();

            return Ok(customers);
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<CustomerResponse>> GetCustomer(int id)
        {
            var customer = await _context.Customers.FindAsync(id);
            if (customer == null) return NotFound();

            var response = new CustomerResponse
            {
                CustomerId = customer.CustomerId,
                FirstName = customer.FirstName,
                LastName = customer.LastName,
                Email = customer.Email,
                Address = customer.Address,
                PhoneNumber = customer.PhoneNumber
            };

            return Ok(response);
        }

        // Create a New Customer
        [HttpPost]
        public async Task<ActionResult<CustomerResponse>> PostCustomer(CustomerRequest request)
        {
            var customer = new Customer
            {
                CustomerId = $"{_context.Customers.Count() + 1}",
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Password = request.Password, 
                Address = request.Address,
                PhoneNumber = request.PhoneNumber
            };

            _context.Customers.Add(customer);
            await _context.SaveChangesAsync();

            var response = new CustomerResponse
            {
                CustomerId = customer.CustomerId,
                FirstName = customer.FirstName,
                LastName = customer.LastName,
                Email = customer.Email,
                Address = customer.Address,
                PhoneNumber = customer.PhoneNumber
            };

            return CreatedAtAction(nameof(GetCustomer), new { id = customer.CustomerId }, response);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCustomer(int id, CustomerRequest request)
        {
            var customer = await _context.Customers.FindAsync(id);
            if (customer == null) return NotFound();

            customer.FirstName = request.FirstName;
            customer.LastName = request.LastName;
            customer.Email = request.Email;
            customer.Password = request.Password; 
            customer.Address = request.Address;
            customer.PhoneNumber = request.PhoneNumber;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCustomer(int id)
        {
            var customer = await _context.Customers.FindAsync(id);
            if (customer == null) return NotFound();

            _context.Customers.Remove(customer);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
