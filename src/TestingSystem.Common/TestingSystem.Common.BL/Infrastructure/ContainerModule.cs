using Autofac;
using AutoMapper;
using AutoMapper.Extensions.ExpressionMapping;
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
            #region Dependency injection at the Data Access Level.

            // Context.
            InjectContext(builder);

            // Answer Data Service.
            InjectAnswersDataService(builder);

            // Group Data Service.
            // Group Test Data Service.
            // Question.
            // Role Test.
            // Student Test.
            // Test.
            // User.
            // User Role.

            #endregion

            #region Dependency injection at the Business Logic Level.

            // Answer Business Service.
            InjectAnswersBusinessService(builder);

            // Group Business Service.
            // Group Test Business Service.
            // Question.
            // Role Test.
            // Student Test.
            // Test.
            // User.
            // User Role.

            #endregion
        }

        private static void InjectAnswersBusinessService(ContainerBuilder builder)
        {
            builder.RegisterType(typeof(BusinessServices.BaseBusinessService<Answer, AnswerBusinessObject>))
                .As(typeof(IBusinessService<AnswerBusinessObject>))
                .WithParameter("mapper", new MapperConfiguration(cfg =>
                {
                    cfg.AddExpressionMapping();
                    cfg.CreateMap<Answer, AnswerBusinessObject>()
                       .ForMember(nameof(AnswerBusinessObject.QuestionTitle), o => o.MapFrom(s => s.Question.Text));
                    cfg.CreateMap<AnswerBusinessObject, Answer>();
                }).CreateMapper());
        }

        private static void InjectAnswersDataService(ContainerBuilder builder)
        {
            builder.RegisterType(typeof(BaseDatabaseDataService<Answer>))
                .As(typeof(IDataService<Answer>));
        }

        private static void InjectContext(ContainerBuilder builder)
        {
            builder.RegisterType(typeof(EntitiesContext))
                .As(typeof(DbContext));
        }
    }
}
