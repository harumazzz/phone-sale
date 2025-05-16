using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/customers")]
    [ApiController]
    public class CustomersController(PhoneShopContext context) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<CustomerResponse>>>> GetCustomers()
        {
            try
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

                return HandleSuccess(customers, "Customers retrieved successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving customers", ex);
            }
        }
          [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<CustomerResponse>>> GetCustomer(int id)
        {
            try
            {
                var customer = await _context.Customers.FindAsync(id);
                if (customer == null)
                {
                    return HandleNotFound<CustomerResponse>("Customer", id);
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

                return HandleSuccess(response, $"Customer with ID {id} retrieved successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving customer with ID {id}", ex);
            }
        }        // Create a New Customer
        [HttpPost]
        public async Task<ActionResult<ApiResponse<CustomerResponse>>> PostCustomer(CustomerRequest request)
        {
            try
            {
                // Validate request
                if (string.IsNullOrEmpty(request.Email))
                {
                    return HandleBadRequest<CustomerResponse>("Email is required");
                }
                
                if (string.IsNullOrEmpty(request.Password))
                {
                    return HandleBadRequest<CustomerResponse>("Password is required");
                }
                
                // Check if email is already in use
                var emailExists = await _context.Customers.AnyAsync(c => c.Email == request.Email);
                if (emailExists)
                {
                    return HandleConflict<CustomerResponse>($"Email {request.Email} is already in use");
                }
                
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

                return HandleCreated(nameof(GetCustomer), new { id = customer.CustomerId }, response, "Customer created successfully");
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
                throw new Exception("Error creating customer", ex);
            }
        }        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> PutCustomer(int id, CustomerRequest request)
        {
            try
            {
                var customer = await _context.Customers.FindAsync(id);
                if (customer == null)
                {
                    return HandleNotFound<object>("Customer", id);
                }

                // Validate request
                if (string.IsNullOrEmpty(request.Email))
                {
                    return HandleBadRequest<object>("Email is required");
                }
                
                // Check if email is already in use by another customer
                var emailExists = await _context.Customers.AnyAsync(c => c.Email == request.Email && c.CustomerId != id.ToString());
                if (emailExists)
                {
                    return HandleConflict<object>($"Email {request.Email} is already in use by another customer");
                }

                customer.FirstName = request.FirstName;
                customer.LastName = request.LastName;
                customer.Email = request.Email;
                customer.Password = request.Password;
                customer.Address = request.Address;
                customer.PhoneNumber = request.PhoneNumber;

                await _context.SaveChangesAsync();
                return HandleSuccess($"Customer with ID {id} updated successfully");
            }
            catch (NotFoundException)
            {
                throw;
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
                throw new Exception($"Error updating customer with ID {id}", ex);
            }
        }        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteCustomer(int id)
        {
            try
            {
                var customer = await _context.Customers.FindAsync(id);
                if (customer == null)
                {
                    return HandleNotFound<object>("Customer", id);
                }

                // Check if customer has any orders
                var hasOrders = await _context.Orders.AnyAsync(o => o.CustomerId == id.ToString());
                if (hasOrders)
                {
                    return HandleConflict<object>($"Cannot delete customer with ID {id} as they have existing orders");
                }
                
                // Check if customer has items in cart
                var hasCartItems = await _context.Carts.AnyAsync(c => c.CustomerId == id.ToString());
                if (hasCartItems)
                {
                    return HandleConflict<object>($"Cannot delete customer with ID {id} as they have items in their cart");
                }
                
                // Check if customer has any wishlists
                var hasWishlists = await _context.Wishlists.AnyAsync(w => w.CustomerId == id.ToString());
                if (hasWishlists)
                {
                    return HandleConflict<object>($"Cannot delete customer with ID {id} as they have items in their wishlist");
                }

                _context.Customers.Remove(customer);
                await _context.SaveChangesAsync();
                return HandleSuccess($"Customer with ID {id} deleted successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (ConflictException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error deleting customer with ID {id}", ex);
            }
        }
    }
}
