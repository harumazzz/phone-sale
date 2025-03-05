using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class OrderShipmentResponse
    {
        [Required]
        public required int OrderId { get; set; }
        [Required]
        public required int ShipmentId { get; set; }
    }

}
