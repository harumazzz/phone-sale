using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/categories")]
    [ApiController]
    public class CategoryController(PhoneShopContext context) : ApiControllerBase
    {
        private readonly PhoneShopContext _context = context;        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<CategoryResponse>>>> GetCategories()
        {
            try
            {
                var categories = await _context.Categories.Select((e) => new CategoryResponse {
                    Id = e.CategoryId,
                    Name = e.Name,
                }).ToListAsync();
                
                return HandleSuccess(categories, "Categories retrieved successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving categories", ex);
            }
        }        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<CategoryResponse>>> GetCategory(int id)
        {
            try
            {
                var category = await _context.Categories.FindAsync(id);
                if (category == null)
                {
                    return HandleNotFound<CategoryResponse>("Category", id);
                }
                
                var response = new CategoryResponse { 
                    Id = category.CategoryId,
                    Name = category.Name,
                };
                
                return HandleSuccess(response, $"Category with ID {id} retrieved successfully");
            }
            catch (NotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving category with ID {id}", ex);
            }
        }        [HttpPost]
        public async Task<ActionResult<ApiResponse<CategoryResponse>>> CreateCategory(CategoryRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Name))
                {
                    return HandleBadRequest<CategoryResponse>("Category name cannot be empty");
                }
                
                // Check if category with same name already exists
                var categoryExists = await _context.Categories.AnyAsync(c => c.Name == request.Name);
                if (categoryExists)
                {
                    return HandleConflict<CategoryResponse>($"A category with name '{request.Name}' already exists");
                }
                
                var category = new Category
                {
                    Name = request.Name
                };
                
                _context.Categories.Add(category);
                await _context.SaveChangesAsync();
                
                var response = new CategoryResponse
                {
                    Id = category.CategoryId,
                    Name = category.Name
                };
                
                return HandleCreated(nameof(GetCategory), new { id = category.CategoryId }, response, "Category created successfully");
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
                throw new Exception("Error creating category", ex);
            }
        }        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> UpdateCategory(int id, CategoryRequest request)
        {
            try
            {
                var category = await _context.Categories.FindAsync(id);
                if (category == null)
                {
                    return HandleNotFound<object>("Category", id);
                }
                
                if (string.IsNullOrWhiteSpace(request.Name))
                {
                    return HandleBadRequest<object>("Category name cannot be empty");
                }
                
                // Check if another category with same name already exists
                var categoryExists = await _context.Categories
                    .AnyAsync(c => c.Name == request.Name && c.CategoryId != id);
                
                if (categoryExists)
                {
                    return HandleConflict<object>($"Another category with name '{request.Name}' already exists");
                }
                
                category.Name = request.Name;
                await _context.SaveChangesAsync();
                
                return HandleSuccess($"Category with ID {id} updated successfully");
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
                throw new Exception($"Error updating category with ID {id}", ex);
            }
        }        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteCategory(int id)
        {
            try
            {
                var category = await _context.Categories.FindAsync(id);
                if (category == null)
                {
                    return HandleNotFound<object>("Category", id);
                }
                
                // Check if category is used in any products
                var isUsedInProducts = await _context.Products.AnyAsync(p => p.CategoryId == id);
                if (isUsedInProducts)
                {
                    return HandleConflict<object>($"Cannot delete category with ID {id} as it is used in one or more products");
                }
                
                _context.Categories.Remove(category);
                await _context.SaveChangesAsync();
                
                return HandleSuccess($"Category with ID {id} deleted successfully");
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
                throw new Exception($"Error deleting category with ID {id}", ex);
            }
        }
    }
}
