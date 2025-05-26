using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/discounts")]
    [ApiController]
    public class DiscountController(PhoneShopContext context) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<DiscountResponse>>>> GetDiscounts()
        {
            try
            {
                var discounts = await _context.Discounts
                    .Select(d => new DiscountResponse
                    {
                        DiscountId = d.DiscountId,
                        Code = d.Code,
                        Description = d.Description,
                        DiscountType = d.DiscountType,
                        DiscountValue = d.DiscountValue,
                        MinOrderValue = d.MinOrderValue,
                        IsActive = d.IsActive,
                        ValidFrom = d.ValidFrom,
                        ValidTo = d.ValidTo,
                        MaxUses = d.MaxUses,
                        CurrentUses = d.CurrentUses
                    })
                    .ToListAsync();

                return HandleSuccess(discounts, "Discounts retrieved successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving discounts", ex);
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<DiscountResponse>>> GetDiscount(int id)
        {
            try
            {
                var discount = await _context.Discounts.FindAsync(id);
                if (discount == null)
                {
                    return HandleNotFound<DiscountResponse>("Discount", id.ToString());
                }

                var response = new DiscountResponse
                {
                    DiscountId = discount.DiscountId,
                    Code = discount.Code,
                    Description = discount.Description,
                    DiscountType = discount.DiscountType,
                    DiscountValue = discount.DiscountValue,
                    MinOrderValue = discount.MinOrderValue,
                    IsActive = discount.IsActive,
                    ValidFrom = discount.ValidFrom,
                    ValidTo = discount.ValidTo,
                    MaxUses = discount.MaxUses,
                    CurrentUses = discount.CurrentUses
                };

                return HandleSuccess(response, "Discount retrieved successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving discount", ex);
            }
        }

        [HttpPost]
        public async Task<ActionResult<ApiResponse<DiscountResponse>>> CreateDiscount(DiscountRequest discountRequest)
        {
            try
            {
                // Check if a discount with the same code already exists
                var existingDiscount = await _context.Discounts.FirstOrDefaultAsync(d => d.Code == discountRequest.Code);
                if (existingDiscount != null)
                {
                    return HandleBadRequest<DiscountResponse>($"Discount with code '{discountRequest.Code}' already exists");
                }

                var discount = new Discount
                {
                    Code = discountRequest.Code,
                    Description = discountRequest.Description,
                    DiscountType = discountRequest.DiscountType,
                    DiscountValue = discountRequest.DiscountValue,
                    MinOrderValue = discountRequest.MinOrderValue,
                    IsActive = discountRequest.IsActive,
                    ValidFrom = discountRequest.ValidFrom,
                    ValidTo = discountRequest.ValidTo,
                    MaxUses = discountRequest.MaxUses,
                    CurrentUses = 0
                };

                _context.Discounts.Add(discount);
                await _context.SaveChangesAsync();

                var response = new DiscountResponse
                {
                    DiscountId = discount.DiscountId,
                    Code = discount.Code,
                    Description = discount.Description,
                    DiscountType = discount.DiscountType,
                    DiscountValue = discount.DiscountValue,
                    MinOrderValue = discount.MinOrderValue,
                    IsActive = discount.IsActive,
                    ValidFrom = discount.ValidFrom,
                    ValidTo = discount.ValidTo,
                    MaxUses = discount.MaxUses,
                    CurrentUses = discount.CurrentUses
                };

                return HandleSuccess(response, "Discount created successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error creating discount", ex);
            }
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<DiscountResponse>>> UpdateDiscount(int id, DiscountRequest discountRequest)
        {
            try
            {
                var discount = await _context.Discounts.FindAsync(id);
                if (discount == null)
                {
                    return HandleNotFound<DiscountResponse>("Discount", id.ToString());
                }

                // Check if another discount with the same code exists
                var existingDiscount = await _context.Discounts
                    .FirstOrDefaultAsync(d => d.Code == discountRequest.Code && d.DiscountId != id);
                
                if (existingDiscount != null)
                {
                    return HandleBadRequest<DiscountResponse>($"Another discount with code '{discountRequest.Code}' already exists");
                }

                discount.Code = discountRequest.Code;
                discount.Description = discountRequest.Description;
                discount.DiscountType = discountRequest.DiscountType;
                discount.DiscountValue = discountRequest.DiscountValue;
                discount.MinOrderValue = discountRequest.MinOrderValue;
                discount.IsActive = discountRequest.IsActive;
                discount.ValidFrom = discountRequest.ValidFrom;
                discount.ValidTo = discountRequest.ValidTo;
                discount.MaxUses = discountRequest.MaxUses;

                _context.Discounts.Update(discount);
                await _context.SaveChangesAsync();

                var response = new DiscountResponse
                {
                    DiscountId = discount.DiscountId,
                    Code = discount.Code,
                    Description = discount.Description,
                    DiscountType = discount.DiscountType,
                    DiscountValue = discount.DiscountValue,
                    MinOrderValue = discount.MinOrderValue,
                    IsActive = discount.IsActive,
                    ValidFrom = discount.ValidFrom,
                    ValidTo = discount.ValidTo,
                    MaxUses = discount.MaxUses,
                    CurrentUses = discount.CurrentUses
                };

                return HandleSuccess(response, "Discount updated successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating discount", ex);
            }
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteDiscount(int id)
        {
            try
            {
                var discount = await _context.Discounts.FindAsync(id);
                if (discount == null)
                {
                    return HandleNotFound<object>("Discount", id.ToString());
                }

                // Check if discount is being used in any orders
                var orderWithDiscount = await _context.Orders.AnyAsync(o => o.DiscountId == id);
                if (orderWithDiscount)
                {
                    return HandleBadRequest<object>("Cannot delete discount as it is being used in orders");
                }

                _context.Discounts.Remove(discount);
                await _context.SaveChangesAsync();

                return HandleSuccess<object>("Discount deleted successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting discount", ex);
            }
        }

        [HttpPost("validate")]
        public async Task<ActionResult<ApiResponse<DiscountValidationResponse>>> ValidateDiscount(ApplyDiscountRequest request)
        {
            try
            {
                var discount = await _context.Discounts
                    .FirstOrDefaultAsync(d => d.Code == request.Code && d.IsActive);

                var response = new DiscountValidationResponse();
                
                if (discount == null)
                {
                    response.IsValid = false;
                    response.Message = "Invalid discount code";
                    return HandleSuccess(response, "Discount validation completed");
                }

                // Check if discount is expired
                var now = DateTime.Now;
                if (now < discount.ValidFrom || now > discount.ValidTo)
                {
                    response.IsValid = false;
                    response.Message = "Discount code has expired or is not yet active";
                    return HandleSuccess(response, "Discount validation completed");
                }

                // Check if discount has reached max uses
                if (discount.MaxUses.HasValue && discount.CurrentUses >= discount.MaxUses.Value)
                {
                    response.IsValid = false;
                    response.Message = "Discount code has reached its maximum usage limit";
                    return HandleSuccess(response, "Discount validation completed");
                }

                // Check if cart total meets minimum order value
                if (request.CartTotal < discount.MinOrderValue)
                {
                    response.IsValid = false;
                    response.Message = $"Minimum order value of {discount.MinOrderValue} not met";
                    return HandleSuccess(response, "Discount validation completed");
                }

                // Calculate discount amount
                decimal discountAmount = 0;
                if (discount.DiscountType == DiscountType.Percentage)
                {
                    discountAmount = request.CartTotal * (discount.DiscountValue / 100);
                }
                else
                {
                    discountAmount = discount.DiscountValue;
                }

                // Ensure discount doesn't exceed total
                if (discountAmount > request.CartTotal)
                {
                    discountAmount = request.CartTotal;
                }

                response.IsValid = true;
                response.DiscountAmount = discountAmount;
                response.FinalPrice = request.CartTotal - discountAmount;
                response.DiscountId = discount.DiscountId;
                response.Message = "Discount applied successfully";
                
                return HandleSuccess(response, "Discount validation completed");
            }
            catch (Exception ex)
            {
                throw new Exception("Error validating discount", ex);
            }
        }
    }
}
