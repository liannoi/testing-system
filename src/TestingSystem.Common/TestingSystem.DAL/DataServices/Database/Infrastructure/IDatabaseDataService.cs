using System.Collections.Generic;

namespace TestingSystem.DAL.DataServices.Database.Infrastructure
{
    public interface IDatabaseDataService<TEntity> where TEntity : class
    {
        void Drop(TEntity entity);
        void Drop(int id);
        TEntity Select(int id);
        IEnumerable<BTEntity> Select<BTEntity>(string query, params object[] parameters) where BTEntity : class;
        IEnumerable<BTEntity> Select<BTEntity>(string query) where BTEntity : class;
        void Insert(TEntity entity);
        void InsertOrUpdate(TEntity entity);
    }
}
