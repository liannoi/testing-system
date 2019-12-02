using AutoMapper;
using Multilayer.DataServices;

namespace TestingSystem.Common.BL.BusinessServices
{
    public class
        BaseBusinessService<TEntity, TBtEntity> : Multilayer.BusinessServices.BaseBusinessService<TEntity, TBtEntity>
        where TEntity : class, new()
        where TBtEntity : class, new()
    {
        public BaseBusinessService(IDataService<TEntity> dataService, IMapper mapper) : base(dataService, mapper)
        {
        }
    }
}