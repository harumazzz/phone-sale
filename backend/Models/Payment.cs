using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("payment")]
    public class Payment
    {
        [Key]
        [Column("payment_id")]
        public int PaymentId { get; set; }

        [Required]
        [Column("payment_date")]
        public DateTime PaymentDate { get; set; } = DateTime.Now;

        [Required, MaxLength(100)]
        [Column("payment_method")]
        public required string PaymentMethod { get; set; }

        [Required, Column("amount", TypeName = "decimal(10,2)")]
        public decimal Amount { get; set; }

        [Required, ForeignKey("Customer")]
        [Column("customer_id")]
        public required string CustomerId { get; set; }
        [JsonIgnore]
        public Customer? Customer { get; set; }
    }
}
