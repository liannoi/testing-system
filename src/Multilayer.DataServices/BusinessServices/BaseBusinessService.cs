using AutoMapper;
using Multilayer.BusinessServices;
using Multilayer.DataServices;
using Multilayer.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

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
            var result = dataService.Add(mapper.Map<TEntity>(entity));
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
            var result = dataService.Remove(mapper.Map<TEntity>(entity));
            return AfterCrud(result);
        }

        public virtual BTEntity Restore(BTEntity entity)
        {
            var result = dataService.Restore(mapper.Map<TEntity>(entity));
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
