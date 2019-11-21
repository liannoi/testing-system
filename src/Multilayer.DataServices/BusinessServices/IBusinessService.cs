﻿using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.BusinessServices
{
    public interface IBusinessService<BTEntity> where BTEntity : class, new()
    {
        BTEntity Add(BTEntity entity);
        BTEntity Update(BTEntity entity);
        IEnumerable<BTEntity> Select();
        BTEntity Select(int id);
        BTEntity Remove(BTEntity entity);
        IEnumerable<BTEntity> Find(Expression<Func<BTEntity, bool>> expression);
    }
}
