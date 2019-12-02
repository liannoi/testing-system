using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public static class Md5DataTools
    {
        public static string ToMd5Hash(string input)
        {
            using (var mD5Hash = MD5.Create())
            {
                var result = string.Empty;
                var data = mD5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));
                return data.Aggregate(result, (current, t) => current + t.ToString("x2"));
            }
        }
    }
}