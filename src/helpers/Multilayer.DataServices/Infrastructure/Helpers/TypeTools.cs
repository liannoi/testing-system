using Multilayer.Infrastructure.Keys;
using System;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Reflection;

namespace Multilayer.Infrastructure.Helpers
{
    public sealed class TypeTools<TEntity> : ITypeTools<TEntity> where TEntity : class, new()
    {
        public Type Type => typeof(TEntity);

        public EntityKeyAttribute FirstKeyAttribute { get; set; }
        public EntityKeyAttribute SecondKeyAttribute { get; set; }

        public TEntity AddOrUpdate(IDbSet<TEntity> entities, TEntity entity, bool isRemoved)
        {
            TEntity find = Find(entities, entity);
            GetProperty("IsRemoved").SetValue(find, isRemoved);
            entities.AddOrUpdate(find);
            return Find(entities, entity);
        }

        public TEntity Find(IDbSet<TEntity> entities, TEntity entity)
        {
            return (SecondKeyAttribute == null)
                ? entities.Find(EntityKeyValue(FirstKeyAttribute, entity))
                : entities.Find(EntityKeyValue(FirstKeyAttribute, entity), EntityKeyValue(SecondKeyAttribute, entity));
        }

        private PropertyInfo GetProperty(string name)
        {
            return Type.GetProperty(name);
        }

        private int EntityKeyValue(IEntityKeyAttribute entityKey, TEntity entity)
        {
            return Convert.ToInt32(GetProperty(entityKey.PropertyName).GetValue(entity));
        }
    }
}
