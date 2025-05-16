// This is a basic update script to help controllers with the new ApiResponse pattern
using System;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Linq;

namespace ControllerUpdater 
{
    class Program
    {
        private static readonly string BaseDirectory = @"C:\Users\Admin\Documents\GitHub\phone-sale\backend\Controllers";
        private static readonly List<string> ExcludedFiles = new List<string> 
        { 
            "ApiControllerBase.cs",
            "CategoryController.cs",
            "ProductsController.cs",
            "AuthController.cs"
        };
        
        static void Main(string[] args)
        {
            Console.WriteLine("Controller Updater Starting...");
            
            var controllerFiles = Directory.GetFiles(BaseDirectory, "*.cs")
                .Where(file => !ExcludedFiles.Contains(Path.GetFileName(file)))
                .ToList();
            
            foreach (var filePath in controllerFiles)
            {
                Console.WriteLine($"Updating {Path.GetFileName(filePath)}...");
                UpdateController(filePath);
            }
            
            Console.WriteLine("All controllers updated successfully!");
        }
        
        private static void UpdateController(string filePath)
        {
            // Read the file content
            var content = File.ReadAllText(filePath);
            
            // Add required usings
            if (!content.Contains("using backend.DTO.Response;") || 
                !content.Contains("using backend.Exceptions;"))
            {
                content = Regex.Replace(content, 
                    @"using backend\.Data;(?:\r?\n|\r)",
                    "using backend.Data;\r\nusing backend.DTO.Response;\r\nusing backend.Exceptions;\r\n");
            }
            
            // Change base class to ApiControllerBase
            content = Regex.Replace(content,
                @"(\s*public\s+class\s+\w+\s*\([^)]*\)\s*:\s*)ControllerBase",
                "$1ApiControllerBase");
    
            // Wrap original methods with try-catch
            content = WrapWithTryCatch(content);
            
            // Update return types to include ApiResponse wrapper
            content = Regex.Replace(content, 
                @"public\s+async\s+Task<ActionResult<([^>]+)>>\s+(\w+)\(",
                "public async Task<ActionResult<ApiResponse<$1>>> $2(");
    
            // Update return statements
            content = Regex.Replace(content, 
                @"return\s+Ok\(([^;]+)\);",
                "return HandleSuccess($1, \"Operation completed successfully\");");
    
            content = Regex.Replace(content, 
                @"return\s+NotFound\(\);",
                "throw new NotFoundException();");
    
            content = Regex.Replace(content, 
                @"return\s+NotFound\(([^;]+)\);",
                "throw new NotFoundException($1);");
    
            content = Regex.Replace(content, 
                @"return\s+BadRequest\(([^;]+)\);",
                "throw new BadRequestException($1);");
    
            content = Regex.Replace(content, 
                @"return\s+NoContent\(\);",
                "return HandleSuccess(\"Operation completed successfully\");");
    
            // Save changes
            File.WriteAllText(filePath, content);
        }
        
        private static string WrapWithTryCatch(string content)
        {
            var methodRegex = new Regex(@"\[Http(Get|Post|Put|Delete)[^\]]*\]\s+public\s+async\s+Task<.*?>\s+(\w+)\([^)]*\)\s*\{\s*([^}]*)\}", RegexOptions.Singleline);
            
            return methodRegex.Replace(content, match =>
            {
                var httpMethod = match.Groups[1].Value;
                var methodName = match.Groups[2].Value;
                var methodBody = match.Groups[3].Value;
                
                return $@"[Http{httpMethod}]
        public async Task<ActionResult<ApiResponse<object>>> {methodName}([parameters])
        {{
            try
            {{
                {methodBody.Trim()}
            }}
            catch (NotFoundException ex)
            {{
                throw;
            }}
            catch (BadRequestException ex)
            {{
                throw;
            }}
            catch (ConflictException ex)
            {{
                throw;
            }}
            catch (Exception ex)
            {{
                throw new Exception(""An error occurred during operation"", ex);
            }}
        }}";
            });
        }
    }
}
