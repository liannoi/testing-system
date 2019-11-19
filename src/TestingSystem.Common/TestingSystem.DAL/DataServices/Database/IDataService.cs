using System.Collections.Generic;

namespace TestingSystem.DAL.DataServices.Database
{
    public interface IDataService<TEntity> where TEntity : class
    {
        void Drop(TEntity entity);
        void Drop(int id);
        TEntity Select(int id);
        IEnumerable<TEntity> Select(string query, params object[] parameters);
        IEnumerable<TEntity> Select(string query);
        void Insert(TEntity entity);
        void AddOrUpdate(TEntity entity);
    }
}
