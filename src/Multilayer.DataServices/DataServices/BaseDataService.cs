using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Linq.Expressions;

namespace Multilayer.DataServices
{
    public abstract class BaseDataService<TEntity> : IDataService<TEntity> where TEntity : class, new()
    {
        private readonly DbContext context;
        private readonly IDbSet<TEntity> entities;

        public BaseDataService(DbContext context)
        {
            this.context = context;
            entities = context.Set<TEntity>();
        }

        public virtual void AddOrUpdate(TEntity entity)
        {
            entities.AddOrUpdate(entity);
        }

        public virtual int Commit()
        {
            return context.SaveChanges();
        }

        public virtual void Remove(TEntity entity)
        {
            entities.Remove(entity);
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
    }
}
