﻿using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using TestingSystem.DAL.DataObjects.Context;

namespace TestingSystem.DAL.DataServices.Database.Infrastructure
{
    public class BaseDatabaseDataService<TEntity> : IDatabaseDataService<TEntity> where TEntity : class
    {
        private readonly BaseContext context;
        private readonly DbSet<TEntity> entities;

        public BaseDatabaseDataService(BaseContext context)
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
            Drop(Select(id));
        }

        public virtual void Insert(TEntity entity)
        {
            entities.Add(entity);
        }

        public virtual TEntity Select(int id)
        {
            return entities.Find(id);
        }

        public virtual IEnumerable<TEntity> Select()
        {
            return entities;
        }

        public virtual IEnumerable<TEntity> Select(string query, params object[] parameters)
        {
            return context.Database.SqlQuery<TEntity>(query, parameters);
        }

        public virtual IEnumerable<TEntity> Select(string query) 
        {
            return context.Database.SqlQuery<TEntity>(query);
        }

        public virtual void InsertOrUpdate(TEntity entity)
        {
            entities.AddOrUpdate(entity);
        }
    }
}
