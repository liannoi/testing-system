using Multilayer.Infrastructure.Helpers;

namespace Multilayer.Infrastructure.Initializers
{
    public interface IDataServiceInitializer<TEntity> where TEntity : class, new()
    {
        string ParameterName { get; set; }
        ITypeTools<TEntity> TypeTools { get; set; }
    }
}