using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models
{
    [Table("order_payment")]
    public class OrderPayment
    {
        [Required, ForeignKey("Order")]
        [Column("order_id")]
        public int OrderId { get; set; }

        [JsonIgnore]
        public required Order Order { get; set; }

        [Required, ForeignKey("Payment")]
        [Column("payment_id")]
        public int PaymentId { get; set; }

        [JsonIgnore]
        public required Payment Payment { get; set; }
    }
}
