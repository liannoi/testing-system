using System.Collections.Generic;

namespace TestingSystem.DAL.DataServices.Database.Infrastructure
{
    public interface IDatabaseDataService<TEntity> where TEntity : class
    {
        void Drop(int id);
        void Drop(TEntity entity);
        void Insert(TEntity entity);
        void InsertOrUpdate(TEntity entity);
        TEntity Select(int id);
        IEnumerable<TEntity> Select();
        IEnumerable<TEntity> Select(string query);
        IEnumerable<TEntity> Select(string query, params object[] parameters);
    }
}