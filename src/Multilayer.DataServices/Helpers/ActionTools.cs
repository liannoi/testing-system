using System;
using System.Data.Entity;
using System.Data.Entity.Migrations;

namespace Multilayer.Helpers
{
    public sealed class ActionTools<TEntity> where TEntity : class, new()
    {
        public static TEntity ActionWithEntity(IDbSet<TEntity> entities, TEntity entity, bool isRemoved)
        {
            var entityId = EntityId(entity);
            TEntity find = entities.Find(entityId);
            typeof(TEntity).GetProperty("IsRemoved").SetValue(find, isRemoved);
            entities.AddOrUpdate(find);
            return entities.Find(entityId);
        }

        public static int EntityId(TEntity entity)
        {
            return Convert.ToInt32(typeof(TEntity).GetProperty($"{typeof(TEntity).Name}Id").GetValue(entity));
        }
    }
}
