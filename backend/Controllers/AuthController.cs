using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using backend.Services;
using backend.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/auth")]
    [ApiController]
    public class AuthController(PhoneShopContext context, IEmailService emailService) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;
        private readonly IEmailService _emailService = emailService;[HttpPost("register")]
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
            }            catch (Exception ex)
            {
                throw new Exception("Error during login", ex);
            }
        }

        [HttpPost("forgot-password")]
        public async Task<ActionResult<ApiResponse<object>>> ForgotPassword([FromBody] ForgotPasswordRequest request)
        {
            try
            {
                // Validate request
                if (string.IsNullOrWhiteSpace(request.Email))
                {
                    return HandleBadRequest<object>("Email cannot be empty");
                }
                
                // Find the customer by email
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == request.Email);
                if (customer == null)
                {
                    // For security reasons, don't reveal that the email doesn't exist
                    // Just return a success message
                    return HandleSuccess("If your email is registered, a password reset email will be sent.");
                }
                
                // Generate a random password
                string newPassword = PasswordGenerator.GenerateRandomPassword(10);
                
                // Update the customer's password
                customer.Password = newPassword;
                await _context.SaveChangesAsync();
                
                // Send the new password via email
                string emailSubject = "Mật khẩu mới của bạn tại Phone Shop";
                string emailBody = $@"
                    <html>
                    <head>
                        <style>
                            body {{ font-family: Arial, sans-serif; color: #333; line-height: 1.6; }}
                            .container {{ max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }}
                            .header {{ background-color: #4CAF50; color: white; padding: 10px; text-align: center; border-radius: 5px 5px 0 0; }}
                            .content {{ padding: 20px; }}
                            .password {{ font-size: 18px; font-weight: bold; color: #4CAF50; background-color: #f9f9f9; padding: 10px; border: 1px dashed #ddd; }}
                            .footer {{ text-align: center; margin-top: 20px; font-size: 12px; color: #777; }}
                        </style>
                    </head>
                    <body>
                        <div class='container'>
                            <div class='header'>
                                <h2>Mật khẩu mới của bạn</h2>
                            </div>
                            <div class='content'>
                                <p>Xin chào {customer.FirstName} {customer.LastName},</p>
                                <p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu của bạn.</p>
                                <p>Mật khẩu mới của bạn là:</p>
                                <p class='password'>{newPassword}</p>
                                <p>Vui lòng đăng nhập bằng mật khẩu mới và đổi mật khẩu ngay sau khi đăng nhập.</p>
                                <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng liên hệ với chúng tôi ngay lập tức.</p>
                                <p>Trân trọng,<br/>Đội ngũ Phone Shop</p>
                            </div>
                            <div class='footer'>
                                <p>Email này được gửi tự động, vui lòng không trả lời email này.</p>
                            </div>
                        </div>
                    </body>
                    </html>
                ";
                
                await _emailService.SendEmailAsync(customer.Email, emailSubject, emailBody, true);
                
                return HandleSuccess("New password has been sent to your email address.");
            }
            catch (BadRequestException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception("Error processing password reset request", ex);
            }
        }
    }
}
