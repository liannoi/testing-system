using Multilayer.DataServices;
using Multilayer.Infrastructure.Helpers;
using System.Data.Entity;

namespace TestingSystem.Common.DAL.DataServices
{
    public class BaseDatabaseDataService<TEntity> : BaseDataService<TEntity> where TEntity : class, new()
    {
        public BaseDatabaseDataService(DbContext context, ITypeTools<TEntity> typeTools) : base(context, typeTools)
        {
        }

        public override TEntity Remove(TEntity entity)
        {
            return typeTools.AddOrUpdate(entities, entity, true);
        }

        public override TEntity Restore(TEntity entity)
        {
            return typeTools.AddOrUpdate(entities, entity, false);
        }
    }
}
