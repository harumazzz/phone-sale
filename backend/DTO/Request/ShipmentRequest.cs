using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class ShipmentRequest
    {
        [Required]
        public required DateTime ShipmentDate { get; set; }
        [Required]
        public required string Address { get; set; }
        [Required]
        public required string City { get; set; }
        [Required]
        public required string State { get; set; }
        [Required]
        public required string Country { get; set; }
        [Required]
        public required string ZipCode { get; set; }
        [Required]
        public required string CustomerId { get; set; }
    }
}
