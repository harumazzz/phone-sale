using backend.Data;
using backend.DTO.Request;
using backend.DTO.Response;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/products")]
    [ApiController]
    public class ProductController(PhoneShopContext context) : ControllerBase
    {
        private readonly PhoneShopContext _context = context;

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductResponse>>> GetProducts()
        {
            var products = await _context.Products.Include(p => p.Category).ToListAsync();
            var responseList = products.Select(p => new ProductResponse
            {
                ProductId = p.ProductId,
                Model = p.Model,
                Description = p.Description,
                Price = p.Price,
                Stock = p.Stock,
                CategoryId = p.CategoryId
            }).ToList();

            return Ok(responseList);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ProductResponse>> GetProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null) return NotFound();

            var response = new ProductResponse
            {
                ProductId = product.ProductId,
                Model = product.Model,
                Description = product.Description,
                Price = product.Price,
                Stock = product.Stock,
                CategoryId = product.CategoryId
            };

            return Ok(response);
        }

        [HttpPost]
        public async Task<ActionResult<ProductResponse>> CreateProduct(ProductRequest productDto)
        {
            var product = new Product
            {
                Model = productDto.Model,
                Description = productDto.Description,
                Price = productDto.Price,
                Stock = productDto.Stock,
                CategoryId = productDto.CategoryId
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
                CategoryId = product.CategoryId
            };

            return CreatedAtAction(nameof(GetProduct), new { id = product.ProductId }, response);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateProduct(int id, ProductRequest productDto)
        {
            var existingProduct = await _context.Products.FindAsync(id);
            if (existingProduct == null) return NotFound();

            existingProduct.Model = productDto.Model;
            existingProduct.Description = productDto.Description;
            existingProduct.Price = productDto.Price;
            existingProduct.Stock = productDto.Stock;
            existingProduct.CategoryId = productDto.CategoryId;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null) return NotFound();

            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

}
