using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    public enum OrderStatus
    {
        Pending = 0,
        Processing = 1,
        Shipped = 2,
        Delivered = 3,
        Cancelled = 4
    }    [Table("order")]
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

        [Column("discount_id")]
        public int? DiscountId { get; set; }

        [Column("discount_amount", TypeName = "decimal(10,2)")]
        public decimal DiscountAmount { get; set; } = 0;

        [Column("original_price", TypeName = "decimal(10,2)")]
        public decimal OriginalPrice { get; set; }

        [Required, ForeignKey("Customer"), Column("customer_id")]
        public required string CustomerId { get; set; }

        [Column("status")]
        public OrderStatus Status { get; set; } = OrderStatus.Pending;

        [JsonIgnore]
        public Customer? Customer { get; set; }
        
        [ForeignKey("DiscountId")]
        [JsonIgnore]
        public Discount? Discount { get; set; }
    }
}
