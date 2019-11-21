using Autofac;
using AutoMapper;
using AutoMapper.Extensions.ExpressionMapping;
using Multilayer.BusinessServices;
using Multilayer.DataServices;
using System;
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
            InjectDataService(builder, typeof(EntitiesContext), typeof(DbContext));

            // Answer Data Service.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Answer>), typeof(IDataService<Answer>));

            // Group Data Service.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Group>), typeof(IDataService<Group>));

            // Group Test Data Service.
            InjectDataService(builder, typeof(BaseDatabaseDataService<GroupTest>), typeof(IDataService<GroupTest>));

            // Question.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Question>), typeof(IDataService<Question>));

            // Role.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Role>), typeof(IDataService<Role>));

            // Student Test.
            InjectDataService(builder, typeof(BaseDatabaseDataService<StudentTest>), typeof(IDataService<StudentTest>));

            // Test.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Test>), typeof(IDataService<Test>));

            // User.
            InjectDataService(builder, typeof(BaseDatabaseDataService<User>), typeof(IDataService<User>));

            // User Role.
            InjectDataService(builder, typeof(BaseDatabaseDataService<UserRole>), typeof(IDataService<UserRole>));

            #endregion

            #region Dependency injection at the Business Logic Level.
            
            // Answer Business Service.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Answer, AnswerBusinessObject>),
                typeof(IBusinessService<AnswerBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Answer, AnswerBusinessObject>()
                            .ForMember(nameof(AnswerBusinessObject.QuestionTitle), o => o.MapFrom(s => s.Question.Text));
                        cfg.CreateMap<AnswerBusinessObject, Answer>();
                    }).CreateMapper()
                });

            // Group Business Service.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Group, GroupBusinessObject>),
                typeof(IBusinessService<GroupBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Group, GroupBusinessObject>();
                        cfg.CreateMap<GroupBusinessObject, Group>();
                    }).CreateMapper()
                });

            // TODO: Correct this.
            // Group Test Business Service.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<GroupTest, GroupTestBusinessObject>),
                typeof(IBusinessService<GroupTestBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<GroupTest, GroupTestBusinessObject>();
                        cfg.CreateMap<GroupTestBusinessObject, GroupTest>();
                    }).CreateMapper()
                });

            // TODO: Correct this.
            // Question.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Question, QuestionBusinessObject>),
                typeof(IBusinessService<QuestionBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Question, QuestionBusinessObject>();
                        cfg.CreateMap<QuestionBusinessObject, Question>();
                    }).CreateMapper()
                });

            // Role.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Role, RoleBusinessObject>),
                typeof(IBusinessService<RoleBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Role, RoleBusinessObject>();
                        cfg.CreateMap<RoleBusinessObject, Role>();
                    }).CreateMapper()
                });

            // TODO: Correct this.
            // Student Test.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<StudentTest, StudentTestBusinessObject>),
                typeof(IBusinessService<StudentTestBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<StudentTest, StudentTestBusinessObject>();
                        cfg.CreateMap<StudentTestBusinessObject, StudentTest>();
                    }).CreateMapper()
                });

            // Test.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Test, TestBusinessObject>),
                typeof(IBusinessService<TestBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Test, TestBusinessObject>();
                        cfg.CreateMap<TestBusinessObject, Test>();
                    }).CreateMapper()
                });

            // User.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<User, UserBusinessObject>),
                typeof(IBusinessService<UserBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<User, UserBusinessObject>();
                        cfg.CreateMap<UserBusinessObject, User>();
                    }).CreateMapper()
                });

            // TODO: Correct this.
            // User Role.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<UserRole, UserRoleBusinessObject>),
                typeof(IBusinessService<UserRoleBusinessObject>),
                new BusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<UserRole, UserRoleBusinessObject>();
                        cfg.CreateMap<UserRoleBusinessObject, UserRole>();
                    }).CreateMapper()
                });

            #endregion
        }

        private void InjectDataService(ContainerBuilder builder, Type registerType, Type asType)
        {
            builder.RegisterType(registerType)
                .As(asType);
        }

        private void InjectBusinessService(ContainerBuilder builder, Type registerType, Type asType, BusinessServiceInitializer serviceInitializer)
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(serviceInitializer.ParameterName, serviceInitializer.MapperConfiguration);
        }
    }
}
