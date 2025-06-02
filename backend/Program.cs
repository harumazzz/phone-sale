using Microsoft.EntityFrameworkCore;
using backend.Data;
using Microsoft.Extensions.FileProviders;
using backend.Middleware;
using backend.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowWebApp", policy =>
    {
        policy.WithOrigins(
                "http://localhost:3000",     // React dev server
                "https://localhost:3000",    // React dev server HTTPS
                "http://localhost:8080",     // Flutter web dev server
                "https://localhost:8080",    // Flutter web dev server HTTPS
                "http://localhost:5000",     // Alternative port
                "https://localhost:5000",    // Alternative port HTTPS
                "http://127.0.0.1:3000",     // Alternative localhost
                "http://127.0.0.1:8080",     // Alternative localhost
                "http://127.0.0.1:5000",      // Alternative localhost
                "http://localhost:5000"
            )
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials(); // Allow credentials for authentication
    });

    // Development policy for easier testing
    options.AddPolicy("Development", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

builder.Services.AddControllers();
builder.Services.AddMemoryCache();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddResponseCaching();
builder.Services.AddDbContext<PhoneShopContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<IEmailService, EmailService>();

var uploadedImagesPath = Path.Combine(builder.Environment.ContentRootPath, "UploadedImages");

if (!Directory.Exists(uploadedImagesPath))
{
    Directory.CreateDirectory(uploadedImagesPath);
}

var app = builder.Build();



app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(uploadedImagesPath),
    RequestPath = "/UploadedImages"
});

// Register exception handling middleware
app.UseExceptionHandlingMiddleware();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Use CORS middleware - use Development policy in development environment
if (app.Environment.IsDevelopment())
{
    app.UseCors("Development");
}
else
{
    app.UseCors("AllowWebApp");
}

app.UseRouting();
app.UseAuthorization();
app.MapControllers();

app.Run();
