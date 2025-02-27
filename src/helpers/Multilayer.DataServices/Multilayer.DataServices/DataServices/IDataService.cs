﻿// Copyright 2020 Maksym Liannoi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.DataServices
{
    public interface IDataService<TEntity> where TEntity : class, new()
    {
        TEntity Add(TEntity entity);
        IEnumerable<TEntity> Select();
        TEntity Select(TEntity entity);
        TEntity Update(TEntity oldEntity, TEntity entity);
        TEntity Remove(TEntity entity);
        TEntity Restore(TEntity entity);
        int Commit();
        IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> expression);
    }
}