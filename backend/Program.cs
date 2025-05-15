using Microsoft.EntityFrameworkCore;
using backend.Data;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowWebApp", builder =>
    {
        builder.AllowAnyOrigin() 
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

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Use CORS middleware
app.UseCors("AllowWebApp");

app.UseRouting();
app.UseAuthorization();
app.MapControllers();

app.Run();
