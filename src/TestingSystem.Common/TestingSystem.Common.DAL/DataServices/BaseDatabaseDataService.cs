using Multilayer.DataServices;
using Multilayer.Helpers;
using System.Data.Entity;

namespace TestingSystem.Common.DAL.DataServices
{
    public class BaseDatabaseDataService<TEntity> : BaseDataService<TEntity> where TEntity : class, new()
    {
        public BaseDatabaseDataService(DbContext context) : base(context)
        {
        }

        public override TEntity Remove(TEntity entity)
        {
            return ActionTools<TEntity>.ActionWithEntity(entities, entity, true);
        }

        public override TEntity Restore(TEntity entity)
        {
            return ActionTools<TEntity>.ActionWithEntity(entities, entity, false);
        }
    }
}
