using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Models
{
    [Table("Customer")]
    public class Customer
    {
        [Key]
        [Column("customer_id")]
        public required string CustomerId { get; set; }

        [Required, MaxLength(100)]
        [Column("first_name")]
        public required string FirstName { get; set; }

        [Required, MaxLength(100)]
        [Column("last_name")]
        public required string LastName { get; set; }

        [Required, EmailAddress, MaxLength(100)]
        [Column("email")]
        public required string Email { get; set; }

        [Required, MaxLength(100)]
        [Column("password")]
        public required string Password { get; set; }

        [Required, MaxLength(255)]
        [Column("address")]
        public required string Address { get; set; }

        [Required, MaxLength(20)]
        [Column("phone_number")]
        public required string PhoneNumber { get; set; }
    }
}

