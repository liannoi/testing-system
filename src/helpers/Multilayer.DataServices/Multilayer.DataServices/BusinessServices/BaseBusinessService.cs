// Copyright 2019 Maksym Liannoi
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

using AutoMapper;
using Multilayer.DataServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace Multilayer.BusinessServices
{
    public class BaseBusinessService<TEntity, BTEntity> : IBusinessService<BTEntity>
        where TEntity : class, new()
        where BTEntity : class, new()
    {
        protected readonly IDataService<TEntity> dataService;
        protected readonly IMapper mapper;

        public BaseBusinessService(IDataService<TEntity> dataService, IMapper mapper)
        {
            this.dataService = dataService;
            this.mapper = mapper;
        }

        public virtual BTEntity Add(BTEntity entity)
        {
            TEntity result = dataService.Add(mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual IEnumerable<BTEntity> Find(Expression<Func<BTEntity, bool>> expression)
        {
            return dataService
                .Find(mapper.Map<Expression<Func<TEntity, bool>>>(expression))
                .Select(s => mapper.Map<BTEntity>(s));
        }

        public virtual BTEntity Remove(BTEntity entity)
        {
            TEntity result = dataService.Remove(mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual BTEntity Restore(BTEntity entity)
        {
            TEntity result = dataService.Restore(mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual IEnumerable<BTEntity> Select()
        {
            return dataService
                .Select()
                .Select(s => mapper.Map<BTEntity>(s));
        }

        public virtual BTEntity Select(BTEntity entity)
        {
            return mapper.Map<BTEntity>(dataService.Select(mapper.Map<TEntity>(entity)));
        }

        public virtual BTEntity Update(BTEntity oldEntity, BTEntity entity)
        {
            TEntity result = dataService.Update(mapper.Map<TEntity>(oldEntity), mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        private BTEntity AfterCrud(TEntity current)
        {
            dataService.Commit();
            return mapper.Map<BTEntity>(dataService.Select(current));
        }
    }
}