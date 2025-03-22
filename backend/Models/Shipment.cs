using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("shipment")]
    public class Shipment
    {
        [Key]
        [Column("shipment_id")]
        public int ShipmentId { get; set; }

        [Required]
        [Column("shipment_date")]
        public DateTime ShipmentDate { get; set; }

        [Required, MaxLength(255)]
        [Column("address")]
        public required string Address { get; set; }

        [Required, MaxLength(100)]
        [Column("city")]
        public required string City { get; set; }

        [Required, MaxLength(50)]
        [Column("state")]
        public required string State { get; set; }

        [Required, MaxLength(50)]
        public required string Country { get; set; }

        [Required, MaxLength(10)]
        public required string ZipCode { get; set; }

        [Required, ForeignKey("Customer")]
        [Column("customer_id")]
        public required string CustomerId { get; set; }

        [JsonIgnore]
        public Customer? Customer { get; set; }
    }
}
