using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class OrderRequest
    {
        [Required]
        public required decimal TotalPrice { get; set; }
        [Required]
        public required int CustomerId { get; set; }
    }

}
