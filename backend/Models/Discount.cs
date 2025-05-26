using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Models
{
    [Table("discount")]
    public class Discount
    {
        [Key]
        [Column("discount_id")]
        public int DiscountId { get; set; }

        [Required]
        [Column("code")]
        [StringLength(50)]
        public required string Code { get; set; }

        [Required]
        [Column("description")]
        [StringLength(255)]
        public required string Description { get; set; }

        [Required]
        [Column("discount_type")]
        public DiscountType DiscountType { get; set; }

        [Required]
        [Column("discount_value", TypeName = "decimal(10,2)")]
        public required decimal DiscountValue { get; set; }

        [Required]
        [Column("min_order_value", TypeName = "decimal(10,2)")]
        public required decimal MinOrderValue { get; set; }

        [Required]
        [Column("is_active")]
        public bool IsActive { get; set; } = true;

        [Required]
        [Column("valid_from")]
        public DateTime ValidFrom { get; set; }

        [Required]
        [Column("valid_to")]
        public DateTime ValidTo { get; set; }

        [Column("max_uses")]
        public int? MaxUses { get; set; }

        [Column("current_uses")]
        public int CurrentUses { get; set; } = 0;
    }

    public enum DiscountType
    {
        Percentage = 0,
        FixedAmount = 1
    }
}
