using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.DataServices
{
    public interface IDataService<TEntity> where TEntity : class, new()
    {
        TEntity Add(TEntity entity);
        IEnumerable<TEntity> Select();
        TEntity Select(int id);
        TEntity Update(int id, TEntity entity);
        TEntity Remove(int id);
        int Commit();
        IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> expression);
    }
}
