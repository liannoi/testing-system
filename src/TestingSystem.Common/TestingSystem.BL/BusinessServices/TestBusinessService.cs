using System.Collections.Generic;
using TestingSystem.BL.BusinessObjects;

namespace TestingSystem.BL.BusinessServices
{
    public sealed class TestBusinessService : BaseBusinessService
    {
        public TestBusinessService() : base()
        {
        }

        public IEnumerable<TestBusinessObject> Get()
        {
            return databaseDataService.Tests.Select<TestBusinessObject>("EXEC dbo.GetTests");
        }
    }
}
