using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers
{
    [Route("api/upload")]
    [ApiController]
    public class UploadController(IWebHostEnvironment environment) : ControllerBase
    {
        private readonly IWebHostEnvironment _environment = environment;

        [HttpPost("image")]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("Chưa có tệp nào được tải lên.");
            }
            const long maxSize = 5 * 1024 * 1024;
            if (file.Length > maxSize)
            {
                return BadRequest($"Kích thước tệp vượt quá giới hạn cho phép ({maxSize / 1024 / 1024}MB).");
            }
            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
            var fileExtension = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (string.IsNullOrEmpty(fileExtension) || !allowedExtensions.Contains(fileExtension))
            {
                return BadRequest("Loại tệp không hợp lệ. Chỉ chấp nhận JPG, JPEG, PNG, GIF.");
            }
            try
            {
                var uploadsFolder = Path.Combine(_environment.ContentRootPath, "UploadedImages");
                var uniqueFileName = $"{Guid.NewGuid()}{fileExtension}";
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream); 
                }
                var relativePath = Path.Combine("UploadedImages", uniqueFileName).Replace("\\", "/");
                var fileUrl = $"{Request.Scheme}://{Request.Host}/{relativePath}";
                return Ok(new
                {
                    message = "Tải ảnh lên thành công!",
                    fileName = uniqueFileName, 
                    originalFileName = file.FileName,
                    relativePath,
                    url = fileUrl 
                });
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Lỗi máy chủ nội bộ: {ex.Message}");
            }
        }
    }
}
