using AutoMapper;
using System.Collections.Generic;
using TestingSystem.BL.BusinessObjects;
using TestingSystem.DAL.DataObjects;

namespace TestingSystem.BL.BusinessServices
{
    public sealed class TestBusinessService : BaseBusinessService
    {
        public TestBusinessService() : base()
        {
        }

        public IEnumerable<TestBusinessObject> Get()
        {
            IEnumerable<Test> found = databaseDataService.Tests.Select();
            var config = new MapperConfiguration(cfg => cfg.CreateMap<IEnumerable<Test>, IEnumerable<TestBusinessObject>>());
            var tmp = Mapper.Map<IEnumerable<TestBusinessObject>>(found);
        }
    }
}
