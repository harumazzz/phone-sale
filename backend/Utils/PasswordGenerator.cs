using System.Security.Cryptography;
using System.Text;

namespace backend.Utils
{
    public static class PasswordGenerator
    {
        public static string GenerateRandomPassword(int length = 8)
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_-+=";
            StringBuilder password = new StringBuilder();
            
            using (var rng = RandomNumberGenerator.Create())
            {
                byte[] randomBytes = new byte[length];
                rng.GetBytes(randomBytes);
                
                for (int i = 0; i < length; i++)
                {
                    password.Append(validChars[randomBytes[i] % validChars.Length]);
                }
            }
            
            return password.ToString();
        }
    }
}
