using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class CategoryRequest
    {
        [Required]
        public required string Name { get; set;  }
    }
}
