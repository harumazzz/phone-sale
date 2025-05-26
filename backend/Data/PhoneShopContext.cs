using backend.Models;
using Microsoft.EntityFrameworkCore;

namespace backend.Data
{    public class PhoneShopContext : DbContext
    {
        public PhoneShopContext(DbContextOptions<PhoneShopContext> options) : base(options) { }

        public DbSet<Customer> Customers { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Cart> Carts { get; set; }
        public DbSet<Wishlist> Wishlists { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<Shipment> Shipments { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<OrderPayment> OrderPayments { get; set; }
        public DbSet<OrderShipment> OrderShipments { get; set; }
        public DbSet<Discount> Discounts { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<OrderPayment>().HasKey(op => new { op.OrderId, op.PaymentId });
            modelBuilder.Entity<OrderShipment>().HasKey(os => new { os.OrderId, os.ShipmentId });
        }
    }
}
