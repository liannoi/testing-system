using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;

namespace Multilayer.DataServices
{
    public class BaseDataService<TEntity> : IDataService<TEntity> where TEntity : class, new()
    {
        protected readonly DbContext context;
        protected readonly IDbSet<TEntity> entities;

        public BaseDataService(DbContext context)
        {
            this.context = context;
            entities = context.Set<TEntity>();
        }

        public virtual int Commit()
        {
            return context.SaveChanges();
        }

        public virtual IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> expression)
        {
            return entities.Where(expression);
        }

        public virtual IEnumerable<TEntity> Select()
        {
            return entities;
        }

        public virtual TEntity Select(int id)
        {
            return entities.Find(id);
        }

        public virtual TEntity Add(TEntity entity)
        {
            return entities.Add(entity);
        }

        public virtual TEntity Update(int id, TEntity entity)
        {
            TEntity find = Select(id);
            context.Entry(find).CurrentValues.SetValues(entity);
            return find;
        }

        public virtual TEntity Remove(int id)
        {
            return entities.Remove(Select(id));
        }
    }
}
