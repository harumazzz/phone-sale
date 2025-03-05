using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("order")]
    public class Order
    {
        [Key]
        [Column("order_id")]
        public int OrderId { get; set; }

        [Required]
        [Column("order_date")]
        public DateTime OrderDate { get; set; } = DateTime.Now;

        [Required, Column("total_price", TypeName = "decimal(10,2)")]
        public required decimal TotalPrice { get; set; }

        [Required, ForeignKey("Customer"), Column("customer_id")]
        public required int CustomerId { get; set; }

        [JsonIgnore]
        public Customer? Customer { get; set; }
    }
}
