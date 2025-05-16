using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/auth")]
    [ApiController]
    public class AuthController(PhoneShopContext context) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;        [HttpPost("register")]
        public async Task<ActionResult<ApiResponse<CustomerResponse>>> Register(RegisterRequest request)
        {
            try
            {
                // Validate request
                if (string.IsNullOrWhiteSpace(request.Email))
                {
                    return HandleBadRequest<CustomerResponse>("Email cannot be empty");
                }
                
                if (string.IsNullOrWhiteSpace(request.Password))
                {
                    return HandleBadRequest<CustomerResponse>("Password cannot be empty");
                }
                
                // Check if email is already used
                var existingCustomer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == request.Email);
                if (existingCustomer != null)
                {
                    return HandleConflict<CustomerResponse>("Email is already in use");
                }
                
                var customer = new Customer
                {
                    CustomerId = $"{_context.Customers.Count() + 1}",
                    Address = request.Address,
                    Email = request.Email,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    Password = request.Password,
                    PhoneNumber = request.PhoneNumber,
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
                
                return HandleSuccess(response, "Registration successful");
            }
            catch (BadRequestException)
            {
                throw;
            }
            catch (ConflictException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception("Error during registration", ex);
            }
        }        [HttpPost("login")]
        public async Task<ActionResult<ApiResponse<CustomerResponse>>> Login([FromBody] LoginRequest request)
        {
            try
            {
                // Validate request
                if (string.IsNullOrWhiteSpace(request.Email))
                {
                    return HandleBadRequest<CustomerResponse>("Email cannot be empty");
                }
                
                if (string.IsNullOrWhiteSpace(request.Password))
                {
                    return HandleBadRequest<CustomerResponse>("Password cannot be empty");
                }
                
                var customer = await _context.Customers.FirstOrDefaultAsync(c => 
                    c.Email == request.Email && c.Password == request.Password);
                
                if (customer == null)
                {
                    throw new UnauthorizedException("Invalid email or password");
                }
                
                var response = new CustomerResponse
                {
                    CustomerId = customer.CustomerId,
                    FirstName = customer.FirstName,
                    LastName = customer.LastName,
                    Email = customer.Email,
                    Address = customer.Address,
                    PhoneNumber = customer.PhoneNumber
                };
                
                return HandleSuccess(response, "Login successful");
            }
            catch (BadRequestException)
            {
                throw;
            }
            catch (UnauthorizedException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception("Error during login", ex);
            }
        }
    }

}
