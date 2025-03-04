using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("order_shipment")]
    public class OrderShipment
    {
        [Required, ForeignKey("Order")]
        [Column("order_id")]
        public required int OrderId { get; set; }

        [JsonIgnore]
        public required Order Order { get; set; }

        [Required, ForeignKey("Shipment")]
        [Column("shipment_id")]
        public required int ShipmentId { get; set; }

        [JsonIgnore]
        public required Shipment Shipment { get; set; }
    }
}
