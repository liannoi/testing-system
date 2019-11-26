using System.Security.Cryptography;
using System.Text;

namespace TestingSystem.Client.Desktop.BL.Helpers
{
    public static class Md5DataTools
    {
        public static string ToMd5Hash(string input)
        {
            using (MD5 mD5Hash = MD5.Create())
            {
                string result = string.Empty;
                byte[] data = mD5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));
                for (int i = 0; i < data.Length; i++)
                {
                    result += data[i].ToString("x2");
                }
                return result;
            }
        }

        public static bool IsSameMd5Hash(string input, string hash)
        {
            return ToMd5Hash(input) == hash;
        }
    }
}
