using Multilayer.Helpers;
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

        public virtual TEntity Select(TEntity entity)
        {
            return entities.Find(ActionTools<TEntity>.EntityId(entity));
        }

        public virtual TEntity Add(TEntity entity)
        {
            return entities.Add(entity);
        }

        public virtual TEntity Update(TEntity oldEntity,TEntity entity)
        {
            context.Entry(Select(oldEntity)).CurrentValues.SetValues(entity);
            return Select(entity);
        }

        public virtual TEntity Remove(TEntity entity)
        {
            return entities.Remove(Select(entity));
        }

        public virtual TEntity Restore(TEntity entity)
        {
            throw new NotSupportedException("This method is implemented in business logic.");
        }
    }
}
