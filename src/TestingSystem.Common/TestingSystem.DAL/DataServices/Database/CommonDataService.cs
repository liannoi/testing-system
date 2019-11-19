using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestingSystem.DAL.DataObjects.Context;

namespace TestingSystem.DAL.DataServices.Database
{
    public class CommonDataService<TEntity> : IDataService<TEntity> where TEntity : class
    {
        private readonly BaseContext context;
        private readonly DbSet<TEntity> entities;

        public CommonDataService(BaseContext context)
        {
            this.context = context;
            entities = context.Set<TEntity>();
        }

        public virtual void Drop(TEntity entity)
        {
            entities.Remove(entity);
        }

        public virtual void Drop(int id)
        {
            Drop(entities.Find(id));
        }

        public virtual void Insert(TEntity entity)
        {
            entities.Add(entity);
        }

        public virtual TEntity Select(int id)
        {
            throw new NotImplementedException();
        }

        public virtual IEnumerable<TEntity> Select(string query, params object[] parameters)
        {
            throw new NotImplementedException();
        }

        public virtual IEnumerable<TEntity> Select(string query)
        {
            throw new NotImplementedException();
        }

        public virtual void AddOrUpdate(TEntity entity)
        {
            entities.AddOrUpdate(entity);
        }
    }
}
