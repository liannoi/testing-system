using System;
using System.Data.Entity;
using Multilayer.Infrastructure.Keys;

namespace Multilayer.Infrastructure.Helpers
{
    public interface ITypeTools<TEntity> where TEntity : class, new()
    {
        EntityKeyAttribute FirstKeyAttribute { get; set; }
        EntityKeyAttribute SecondKeyAttribute { get; set; }
        Type Type { get; }

        TEntity Find(IDbSet<TEntity> entities, TEntity entity);
        TEntity AddOrUpdate(IDbSet<TEntity> entities, TEntity entity, bool isRemoved);
    }
}