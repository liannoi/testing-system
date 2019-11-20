using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.DataServices
{
    public interface IDataService<TEntity> where TEntity : class, new()
    {
        void AddOrUpdate(TEntity entity);
        IEnumerable<TEntity> Select();
        TEntity Select(int id);
        void Remove(TEntity entity);
        int Commit();
        IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> expression);
    }
}
