using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class ShipmentResponse
    {
        [Required]
        public required int ShipmentId { get; set; }
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
