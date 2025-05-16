using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Exceptions;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{    [Route("api/products")]
    [ApiController]
    public class ProductController(PhoneShopContext context) : ApiControllerBase
    {

        private readonly PhoneShopContext _context = context;        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<ProductResponse>>>> GetProducts()
        {
            try
            {
                var products = await _context.Products.Include(p => p.Category).ToListAsync();
                var responseList = products.Select(p => new ProductResponse
                {
                    ProductId = p.ProductId,
                    Model = p.Model,
                    Description = p.Description,
                    Price = p.Price,
                    Stock = p.Stock,
                    CategoryId = p.CategoryId,
                    ProductLink = p.ProductLink,
                }).ToList();

                return HandleSuccess(responseList, "Products retrieved successfully");
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving products", ex);
            }
        }[HttpGet("/api/products/category/{id}")]
        public async Task<ActionResult<ApiResponse<List<ProductResponse>>>> GetProductsByCategoryId(int id)
        {
            try
            {
                var category = await _context.Categories.FindAsync(id);
                if (category == null)
                {
                    throw new NotFoundException("Category", id);
                }
                
                var products = await _context.Products.Where(e => e.CategoryId == id).Include(p => p.Category).ToListAsync();
                var responseList = products.Select(p => new ProductResponse
                {
                    ProductId = p.ProductId,
                    Model = p.Model,
                    Description = p.Description,
                    Price = p.Price,
                    Stock = p.Stock,
                    CategoryId = p.CategoryId,
                    ProductLink = p.ProductLink,
                }).ToList();

                return Ok(ApiResponse<IEnumerable<ProductResponse>>.SuccessWithData(responseList, $"Products in category {id} retrieved successfully"));
            }
            catch (NotFoundException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving products for category {id}", ex);
            }
        }        [HttpGet("/api/products/search")]
        public async Task<ActionResult<ApiResponse<IEnumerable<ProductResponse>>>> GetProductsByName([FromQuery] string searchQuery)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(searchQuery))
                {
                    throw new BadRequestException("Search query cannot be empty");
                }
                
                var query = _context.Products.Include(p => p.Category);
                var products = await query.Where(p => EF.Functions.Like(p.Model, $"%{searchQuery}%")).ToListAsync();
                var responseList = products.Select(p => new ProductResponse
                {
                    ProductId = p.ProductId,
                    Model = p.Model,
                    Description = p.Description,
                    Price = p.Price,
                    Stock = p.Stock,
                    CategoryId = p.CategoryId,
                    ProductLink = p.ProductLink,
                }).ToList();

                return Ok(ApiResponse<IEnumerable<ProductResponse>>.SuccessWithData(responseList, $"Found {responseList.Count} products matching '{searchQuery}'"));
            }
            catch (BadRequestException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error searching for products with query: {searchQuery}", ex);
            }
        }        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<ProductResponse>>> GetProduct(int id)
        {
            try
            {
                var product = await _context.Products.FindAsync(id);
                if (product == null)
                {
                    throw new NotFoundException("Product", id);
                }

                var response = new ProductResponse
                {
                    ProductId = product.ProductId,
                    Model = product.Model,
                    Description = product.Description,
                    Price = product.Price,
                    Stock = product.Stock,
                    CategoryId = product.CategoryId,
                    ProductLink = product.ProductLink,
                };

                return Ok(ApiResponse<ProductResponse>.SuccessWithData(response, $"Product with ID {id} retrieved successfully"));
            }
            catch (NotFoundException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving product with ID {id}", ex);
            }
        }        [HttpPost]
        public async Task<ActionResult<ApiResponse<ProductResponse>>> CreateProduct(ProductRequest productDto)
        {
            try
            {
                // Validate the product
                if (productDto.Price < 0)
                {
                    throw new BadRequestException("Price cannot be negative");
                }
                
                if (productDto.Stock < 0)
                {
                    throw new BadRequestException("Stock cannot be negative");
                }
                
                // Check if category exists
                var categoryExists = await _context.Categories.AnyAsync(c => c.CategoryId == productDto.CategoryId);
                if (!categoryExists)
                {
                    throw new BadRequestException($"Category with ID {productDto.CategoryId} does not exist");
                }
                
                var product = new Product
                {
                    Model = productDto.Model,
                    Description = productDto.Description,
                    Price = productDto.Price,
                    Stock = productDto.Stock,
                    CategoryId = productDto.CategoryId,
                    ProductLink = productDto.ProductLink,
                };

                _context.Products.Add(product);
                await _context.SaveChangesAsync();

                var response = new ProductResponse
                {
                    ProductId = product.ProductId,
                    Model = product.Model,
                    Description = product.Description,
                    Price = product.Price,
                    Stock = product.Stock,
                    CategoryId = product.CategoryId,
                    ProductLink = product.ProductLink,
                };

                return CreatedAtAction(
                    nameof(GetProduct), 
                    new { id = product.ProductId }, 
                    ApiResponse<ProductResponse>.SuccessWithData(response, "Product created successfully")
                );
            }
            catch (BadRequestException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception("Error creating product", ex);
            }
        }        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> UpdateProduct(int id, ProductRequest productDto)
        {
            try
            {
                var existingProduct = await _context.Products.FindAsync(id);
                if (existingProduct == null)
                {
                    throw new NotFoundException("Product", id);
                }
                
                // Validate the product
                if (productDto.Price < 0)
                {
                    throw new BadRequestException("Price cannot be negative");
                }
                
                if (productDto.Stock < 0)
                {
                    throw new BadRequestException("Stock cannot be negative");
                }
                
                // Check if category exists
                var categoryExists = await _context.Categories.AnyAsync(c => c.CategoryId == productDto.CategoryId);
                if (!categoryExists)
                {
                    throw new BadRequestException($"Category with ID {productDto.CategoryId} does not exist");
                }

                existingProduct.Model = productDto.Model;
                existingProduct.Description = productDto.Description;
                existingProduct.Price = productDto.Price;
                existingProduct.Stock = productDto.Stock;
                existingProduct.CategoryId = productDto.CategoryId;
                existingProduct.ProductLink = productDto.ProductLink;

                await _context.SaveChangesAsync();
                return Ok(ApiResponse<object>.SuccessWithoutData($"Product with ID {id} updated successfully"));
            }
            catch (NotFoundException ex)
            {
                throw;
            }
            catch (BadRequestException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating product with ID {id}", ex);
            }
        }        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteProduct(int id)
        {
            try
            {
                var product = await _context.Products.FindAsync(id);
                if (product == null)
                {
                    throw new NotFoundException("Product", id);
                }

                // Check if product is used in any order items before deletion
                var isUsedInOrderItems = await _context.OrderItems.AnyAsync(oi => oi.ProductId == id);
                if (isUsedInOrderItems)
                {
                    throw new ConflictException($"Cannot delete product with ID {id} as it is referenced in one or more orders");
                }

                // Check if product is in any cart
                var isInCart = await _context.Carts.AnyAsync(c => c.ProductId == id);
                if (isInCart)
                {
                    throw new ConflictException($"Cannot delete product with ID {id} as it is in one or more shopping carts");
                }

                // Check if product is in any wishlist
                var isInWishlist = await _context.Wishlists.AnyAsync(w => w.ProductId == id);
                if (isInWishlist)
                {
                    throw new ConflictException($"Cannot delete product with ID {id} as it is in one or more wishlists");
                }

                _context.Products.Remove(product);
                await _context.SaveChangesAsync();
                return Ok(ApiResponse<object>.SuccessWithoutData($"Product with ID {id} deleted successfully"));
            }
            catch (NotFoundException ex)
            {
                throw;
            }
            catch (ConflictException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error deleting product with ID {id}", ex);
            }
        }
    }

}
