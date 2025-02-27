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

using Multilayer.Infrastructure.Helpers;
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
        protected readonly ITypeTools<TEntity> typeTools;

        public BaseDataService(DbContext context, ITypeTools<TEntity> typeTools)
        {
            this.context = context;
            entities = context.Set<TEntity>();
            this.typeTools = typeTools;
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
            return typeTools.Find(entities, entity);
        }

        public virtual TEntity Add(TEntity entity)
        {
            return entities.Add(entity);
        }

        public virtual TEntity Update(TEntity oldEntity, TEntity entity)
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