using Autofac;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.Infrastructure;

namespace TestingSystem.Common.ConsoleTest
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            ContainerConfig container = new ContainerConfig();
            var businessService = container.Container.Resolve<IBusinessService<UserRoleBusinessObject>>();
            var result = businessService.Remove(new UserRoleBusinessObject
            {
                UserId = 1
            });
        }
    }
}
