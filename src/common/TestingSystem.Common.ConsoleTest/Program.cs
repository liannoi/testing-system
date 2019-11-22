using Autofac;
using Multilayer.BusinessServices;
using System.Linq;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.Infrastructure;

namespace TestingSystem.Common.ConsoleTest
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            ContainerConfig container = new ContainerConfig();
            IBusinessService<UserRoleBusinessObject> businessService = container.Container.Resolve<IBusinessService<UserRoleBusinessObject>>();
            UserRoleBusinessObject result = businessService.Select().FirstOrDefault();
            System.Console.WriteLine(result.RoleName);
        }
    }
}
