using System;
using System.Data.Entity;
using Autofac;
using AutoMapper;
using AutoMapper.Extensions.ExpressionMapping;
using Multilayer.BusinessServices;
using Multilayer.DataServices;
using Multilayer.Infrastructure.Helpers;
using Multilayer.Infrastructure.Initializers;
using Multilayer.Infrastructure.Keys;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.DAL.DataObjects;
using TestingSystem.Common.DAL.DataServices;

namespace TestingSystem.Common.BL.Infrastructure.Container
{
    public sealed class ContainerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            #region Dependency injection at the Data Access Level.

            // Context.
            InjectDataService(builder, typeof(EntitiesContext), typeof(DbContext));

            // Answer Data Service.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Answer>), typeof(IDataService<Answer>),
                new BaseDataServiceInitializer<Answer>
                {
                    TypeTools = new TypeTools<Answer>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(Answer.AnswerId)
                        }
                    }
                });

            // Group Data Service.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Group>), typeof(IDataService<Group>),
                new BaseDataServiceInitializer<Group>
                {
                    TypeTools = new TypeTools<Group>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(Group.GroupId)
                        }
                    }
                });

            // Group Test Data Service.
            InjectDataService(builder, typeof(BaseDatabaseDataService<GroupTest>), typeof(IDataService<GroupTest>),
                new BaseDataServiceInitializer<GroupTest>
                {
                    TypeTools = new TypeTools<GroupTest>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(GroupTest.RecordId)
                        }
                    }
                });

            // Question.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Question>), typeof(IDataService<Question>),
                new BaseDataServiceInitializer<Question>
                {
                    TypeTools = new TypeTools<Question>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(Question.QuestionId)
                        }
                    }
                });

            // Role.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Role>), typeof(IDataService<Role>),
                new BaseDataServiceInitializer<Role>
                {
                    TypeTools = new TypeTools<Role>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(Role.RoleId)
                        }
                    }
                });

            // Student Test.
            InjectDataService(builder, typeof(BaseDatabaseDataService<StudentTest>), typeof(IDataService<StudentTest>),
                new BaseDataServiceInitializer<StudentTest>
                {
                    TypeTools = new TypeTools<StudentTest>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(StudentTest.RecordId)
                        }
                    }
                });

            // Test.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Test>), typeof(IDataService<Test>),
                new BaseDataServiceInitializer<Test>
                {
                    TypeTools = new TypeTools<Test>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(Test.TestId)
                        }
                    }
                });

            // User.
            InjectDataService(builder, typeof(BaseDatabaseDataService<User>), typeof(IDataService<User>),
                new BaseDataServiceInitializer<User>
                {
                    TypeTools = new TypeTools<User>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(User.UserId)
                        }
                    }
                });

            // User Role.
            InjectDataService(builder, typeof(BaseDatabaseDataService<UserRole>), typeof(IDataService<UserRole>),
                new BaseDataServiceInitializer<UserRole>
                {
                    TypeTools = new TypeTools<UserRole>
                    {
                        FirstKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(UserRole.UserId)
                        },
                        SecondKeyAttribute = new EntityKeyAttribute
                        {
                            PropertyName = nameof(UserRole.RoleId)
                        }
                    }
                });

            #endregion

            #region Dependency injection at the Business Logic Level.

            // Answer Business Service.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Answer, AnswerBusinessObject>),
                typeof(IBusinessService<AnswerBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Answer, AnswerBusinessObject>()
                            .ForMember(nameof(AnswerBusinessObject.QuestionTitle),
                                o => o.MapFrom(s => s.Question.Text));
                        cfg.CreateMap<AnswerBusinessObject, Answer>();
                    }).CreateMapper()
                });

            // Group Business Service.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Group, GroupBusinessObject>),
                typeof(IBusinessService<GroupBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Group, GroupBusinessObject>();
                        cfg.CreateMap<GroupBusinessObject, Group>();
                    }).CreateMapper()
                });

            // Group Test Business Service.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<GroupTest, GroupTestBusinessObject>),
                typeof(IBusinessService<GroupTestBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<GroupTest, GroupTestBusinessObject>()
                            .ForMember(nameof(GroupTestBusinessObject.GroupName), o => o.MapFrom(s => s.Group.Name))
                            .ForMember(nameof(GroupTestBusinessObject.TestName), o => o.MapFrom(s => s.Test.Title));
                        cfg.CreateMap<GroupTestBusinessObject, GroupTest>();
                    }).CreateMapper()
                });

            // Question.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Question, QuestionBusinessObject>),
                typeof(IBusinessService<QuestionBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Question, QuestionBusinessObject>()
                            .ForMember(nameof(QuestionBusinessObject.Question), o => o.MapFrom(s => s.Text))
                            .ForMember(nameof(QuestionBusinessObject.TestName), o => o.MapFrom(s => s.Test.Title));
                        cfg.CreateMap<QuestionBusinessObject, Question>();
                    }).CreateMapper()
                });

            // Role.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Role, RoleBusinessObject>),
                typeof(IBusinessService<RoleBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<Role, RoleBusinessObject>();
                        cfg.CreateMap<RoleBusinessObject, Role>();
                    }).CreateMapper()
                });

            // Student Test.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<StudentTest, StudentTestBusinessObject>),
                typeof(IBusinessService<StudentTestBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<StudentTest, StudentTestBusinessObject>()
                            .ForMember(nameof(StudentTestBusinessObject.UserName),
                                o => o.MapFrom(s => $"{s.User.LastName} {s.User.FirstName} {s.User.MiddleName}"))
                            .ForMember(nameof(StudentTestBusinessObject.TestName), o => o.MapFrom(s => s.Test.Title));
                        cfg.CreateMap<StudentTestBusinessObject, StudentTest>();
                    }).CreateMapper()
                });

            // Test.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<Test, TestBusinessObject>),
                typeof(IBusinessService<TestBusinessObject>),
                new BaseBusinessServiceInitializer
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
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<User, UserBusinessObject>();
                        cfg.CreateMap<UserBusinessObject, User>();
                    }).CreateMapper()
                });

            // User Role.
            InjectBusinessService(builder,
                typeof(BusinessServices.BaseBusinessService<UserRole, UserRoleBusinessObject>),
                typeof(IBusinessService<UserRoleBusinessObject>),
                new BaseBusinessServiceInitializer
                {
                    MapperConfiguration = new MapperConfiguration(cfg =>
                    {
                        cfg.AddExpressionMapping();
                        cfg.CreateMap<UserRole, UserRoleBusinessObject>()
                            .ForMember(nameof(UserRoleBusinessObject.UserName),
                                o => o.MapFrom(s => $"{s.User.LastName} {s.User.FirstName} {s.User.MiddleName}"))
                            .ForMember(nameof(UserRoleBusinessObject.RoleName), o => o.MapFrom(s => s.Role.Name));
                        cfg.CreateMap<UserRoleBusinessObject, UserRole>();
                    }).CreateMapper()
                });

            #endregion
        }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private void InjectDataService(ContainerBuilder builder, Type registerType, Type asType)
        {
            builder.RegisterType(registerType)
                .As(asType);
        }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private void InjectDataService<TEntity>(ContainerBuilder builder, Type registerType, Type asType,
            IDataServiceInitializer<TEntity> dataServiceInitializer) where TEntity : class, new()
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(dataServiceInitializer.ParameterName, dataServiceInitializer.TypeTools);
        }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private void InjectBusinessService(ContainerBuilder builder, Type registerType, Type asType,
            IBusinessServiceInitializer businessServiceInitializer)
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(businessServiceInitializer.ParameterName,
                    businessServiceInitializer.MapperConfiguration);
        }
    }
}