using Autofac;
using Multilayer.BusinessServices;
using Multilayer.DataServices;
using System.Data.Entity;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices;
using TestingSystem.Common.DAL.DataObjects;
using TestingSystem.Common.DAL.DataServices;

namespace TestingSystem.Common.BL.Infrastructure
{
    public sealed class ContainerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            // DAL.
            builder.RegisterType(typeof(AnswersMarkableDataService)).As(typeof(IDataService<Answer>));
            builder.RegisterType(typeof(EntitiesContext)).As(typeof(DbContext));

            // BL.
            builder.RegisterType(typeof(AnswersBusinessService)).As(typeof(IBusinessService<AnswerBusinessObject>));
        }
    }
}
