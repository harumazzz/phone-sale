using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("wishlist")]
    public class Wishlist
    {
        [Key]
        [Column("wishlist_id")]
        public int WishlistId { get; set; }

        [Required, ForeignKey("Customer")]
        [Column("customer_id")]
        public int CustomerId { get; set; }

        [JsonIgnore]
        public Customer? Customer { get; set; }

        [Required, ForeignKey("Product")]
        [Column("product_id")]
        public int ProductId { get; set; }

        [JsonIgnore]
        public Product? Product { get; set; }
    }
}
