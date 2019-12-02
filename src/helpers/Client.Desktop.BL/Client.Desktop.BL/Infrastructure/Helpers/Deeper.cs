using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public static class Deeper<TIn, TOut>
        where TIn : class, new()
        where TOut : class, new()
    {
        public static TIn Clone(TOut fromObject)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
                BinaryFormatter binaryFormatter = new BinaryFormatter();
                binaryFormatter.Serialize(memoryStream, fromObject);
                memoryStream.Seek(0, SeekOrigin.Begin);
                return binaryFormatter.Deserialize(memoryStream) as TIn;
            }
        }
    }
}
