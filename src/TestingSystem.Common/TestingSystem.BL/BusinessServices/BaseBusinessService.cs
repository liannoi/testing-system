using TestingSystem.DAL.DataObjects;
using TestingSystem.DAL.DataServices;

namespace TestingSystem.BL.BusinessServices
{
    public class BaseBusinessService
    {
        protected readonly DatabaseDataService databaseDataService;

        public BaseBusinessService()
        {
            databaseDataService = new DatabaseDataService(new EntitiesContext());
        }
    }
}
