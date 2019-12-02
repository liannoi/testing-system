using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.DataServices
{
    public interface IDataService<TEntity> where TEntity : class, new()
    {
        TEntity Add(TEntity entity);
        IEnumerable<TEntity> Select();
        TEntity Select(TEntity entity);
        TEntity Update(TEntity oldEntity, TEntity entity);
        TEntity Remove(TEntity entity);
        TEntity Restore(TEntity entity);
        int Commit();
        IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> expression);
    }
}