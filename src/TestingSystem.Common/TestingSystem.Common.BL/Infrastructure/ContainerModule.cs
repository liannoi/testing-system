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
            // DAL.
            builder.RegisterType(typeof(BaseDatabaseDataService<Answer>))
                .As(typeof(IDataService<Answer>));
            builder.RegisterType(typeof(EntitiesContext))
                .As(typeof(DbContext));

            // BL.
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
    }
}
