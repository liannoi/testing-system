using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.BusinessServices
{
    public interface IBusinessService<BTEntity> where BTEntity : class, new()
    {
        BTEntity Add(BTEntity entity);
        BTEntity Update(BTEntity oldEntity, BTEntity entity);
        IEnumerable<BTEntity> Select();
        BTEntity Select(BTEntity entity);
        BTEntity Remove(BTEntity entity);
        BTEntity Restore(BTEntity entity);
        IEnumerable<BTEntity> Find(Expression<Func<BTEntity, bool>> expression);
    }
}