using Multilayer.Infrastructure.Helpers;

namespace Multilayer.Infrastructure.Initializers
{
    public class BaseDataServiceInitializer<TEntity> : IDataServiceInitializer<TEntity> where TEntity : class, new()
    {
        public string ParameterName { get; set; } = "typeTools";

        public ITypeTools<TEntity> TypeTools { get; set; }
    }
}