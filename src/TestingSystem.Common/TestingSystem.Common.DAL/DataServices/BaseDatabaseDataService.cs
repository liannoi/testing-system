using Multilayer.DataServices;
using System.Data.Entity;

namespace TestingSystem.Common.DAL.DataServices
{
    public class BaseDatabaseDataService<TEntity> : BaseDataService<TEntity> where TEntity : class, new()
    {
        public BaseDatabaseDataService(DbContext context) : base(context)
        {
        }
    }
}
