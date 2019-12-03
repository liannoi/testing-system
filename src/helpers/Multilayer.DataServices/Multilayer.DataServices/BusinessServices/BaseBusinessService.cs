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

using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using AutoMapper;
using Multilayer.DataServices;

namespace Multilayer.BusinessServices
{
    public class BaseBusinessService<TEntity, TBEntity> : IBusinessService<TBEntity>
        where TEntity : class, new()
        where TBEntity : class, new()
    {
        protected readonly IDataService<TEntity> DataService;
        protected readonly IMapper Mapper;

        public BaseBusinessService(IDataService<TEntity> dataService, IMapper mapper)
        {
            this.DataService = dataService;
            this.Mapper = mapper;
        }

        public virtual TBEntity Add(TBEntity entity)
        {
            var result = DataService.Add(Mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual IEnumerable<TBEntity> Find(Expression<Func<TBEntity, bool>> expression)
        {
            return DataService
                .Find(Mapper.Map<Expression<Func<TEntity, bool>>>(expression))
                .Select(s => Mapper.Map<TBEntity>(s));
        }

        public virtual TBEntity Remove(TBEntity entity)
        {
            var result = DataService.Remove(Mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual TBEntity Restore(TBEntity entity)
        {
            var result = DataService.Restore(Mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual IEnumerable<TBEntity> Select()
        {
            return DataService
                .Select()
                .Select(s => Mapper.Map<TBEntity>(s));
        }

        public virtual TBEntity Select(TBEntity entity)
        {
            return Mapper.Map<TBEntity>(DataService.Select(Mapper.Map<TEntity>(entity)));
        }

        public virtual TBEntity Update(TBEntity oldEntity, TBEntity entity)
        {
            var result = DataService.Update(Mapper.Map<TEntity>(oldEntity), Mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        private TBEntity AfterCrud(TEntity current)
        {
            DataService.Commit();
            return Mapper.Map<TBEntity>(DataService.Select(current));
        }
    }
}