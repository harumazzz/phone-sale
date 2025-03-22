using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("cart")]
    public class Cart
    {
        [Key]
        [Column("cart_id")]
        public int CartId { get; set; }

        [Required]
        [Column("quantity")]
        public int Quantity { get; set; }

        [Required, ForeignKey("Customer")]
        [Column("customer_id")]
        public required string CustomerId { get; set; }

        [JsonIgnore]
        public Customer? Customer { get; set; }

        [Required, ForeignKey("Product")]
        [Column("product_id")]
        public required int ProductId { get; set; }

        [JsonIgnore]
        public Product? Product { get; set; }
    }
}
