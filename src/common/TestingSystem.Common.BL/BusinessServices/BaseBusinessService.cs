using AutoMapper;
using Multilayer.DataServices;

namespace TestingSystem.Common.BL.BusinessServices
{
    public class BaseBusinessService<TEntity, BTEntity> : Multilayer.BusinessServices.BaseBusinessService<TEntity, BTEntity>
        where TEntity : class, new()
        where BTEntity : class, new()
    {
        public BaseBusinessService(IDataService<TEntity> dataService, IMapper mapper) : base(dataService, mapper)
        {
        }
    }
}
