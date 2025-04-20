using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("product")]
    public class Product
    {
        [Key]
        [Column("product_id")]
        public int ProductId { get; set; }

        [Required, MaxLength(100)]
        [Column("model")]
        public required string Model { get; set; }

        [MaxLength(255)]
        [Column("description")]
        public string? Description { get; set; }

        [Required, Column("price", TypeName = "decimal(10,2)")]
        public required decimal Price { get; set; }

        [Required]
        [Column("stock")]
        public required int Stock { get; set; }

        [Required, ForeignKey("Category")]
        [Column("category_id")]
        public required int CategoryId { get; set; }

        [JsonIgnore]

        public Category? Category { get; set; }

        [Required, MaxLength(255)]
        [Column("product_link")]
        public required string ProductLink { get; set; }
    }
}
