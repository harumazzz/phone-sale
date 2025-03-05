using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("order_item")]
    public class OrderItem
    {
        [Key]
        [Column("order_item_id")]
        public int OrderItemId { get; set; }

        [Required]
        [Column("quantity")]
        public int Quantity { get; set; }

        [Required, Column("price", TypeName = "decimal(10,2)")]
        public required decimal Price { get; set; }

        [Required, ForeignKey("Product")]
        [Column("product_id")]
        public required int ProductId { get; set; }
        public Product? Product { get; set; }

        [Required, ForeignKey("Order")]
        [Column("order_id")]
        public required int OrderId { get; set; }

        [JsonIgnore]
        public Order? Order { get; set; }
    }
}
