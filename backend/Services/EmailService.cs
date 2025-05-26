using MailKit.Net.Smtp;
using MimeKit;

namespace backend.Services
{
    public interface IEmailService
    {
        Task SendEmailAsync(string to, string subject, string body, bool isHtml = false);
    }

    public class EmailService(IConfiguration configuration, ILogger<EmailService> logger) : IEmailService
    {
        public async Task SendEmailAsync(string to, string subject, string body, bool isHtml = false)
        {
            try
            {
                var emailConfig = configuration.GetSection("EmailSettings");
                var message = new MimeMessage();
                
                message.From.Add(new MailboxAddress(emailConfig["DisplayName"], emailConfig["From"]));
                message.To.Add(new MailboxAddress("", to));
                message.Subject = subject;
                
                var bodyBuilder = new BodyBuilder();
                if (isHtml)
                {
                    bodyBuilder.HtmlBody = body;
                }
                else
                {
                    bodyBuilder.TextBody = body;
                }
                
                message.Body = bodyBuilder.ToMessageBody();
                
                using (var client = new SmtpClient())
                {
                    await client.ConnectAsync(emailConfig["SmtpServer"], 
                        int.Parse(emailConfig["Port"] ?? "587"), 
                        MailKit.Security.SecureSocketOptions.StartTls);
                    
                    if (!string.IsNullOrEmpty(emailConfig["Username"]) && !string.IsNullOrEmpty(emailConfig["Password"]))
                    {
                        await client.AuthenticateAsync(emailConfig["Username"], emailConfig["Password"]);
                    }
                    
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }
                
                logger.LogInformation($"Email sent successfully to {to}");
            }
            catch (Exception ex)
            {
                logger.LogError($"Error sending email: {ex.Message}");
                throw;
            }
        }
    }
}
