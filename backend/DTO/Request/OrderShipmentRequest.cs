using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class OrderShipmentRequest
    {
        [Required]
        public required int OrderId { get; set; }
        [Required]
        public required int ShipmentId { get; set; }
    }

}
