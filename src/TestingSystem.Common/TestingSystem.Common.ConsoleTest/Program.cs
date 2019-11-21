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
            IBusinessService<AnswerBusinessObject> businessService = container.Container.Resolve<IBusinessService<AnswerBusinessObject>>();
            businessService.Remove(new AnswerBusinessObject
            {
                AnswerId = 7
            });
        }
    }
}
