using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class CategoryResponse
    {
        [Required]
        public required int Id { get; set; }

        [Required]
        public required string Name { get; set;  }
    }
}
