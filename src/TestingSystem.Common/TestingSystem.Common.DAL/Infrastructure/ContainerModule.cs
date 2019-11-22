using Autofac;
using Multilayer.DataServices;
using Multilayer.Infrastructure.Contrainer;
using Multilayer.Infrastructure.Helpers;
using Multilayer.Infrastructure.Initializers;
using Multilayer.Infrastructure.Keys;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestingSystem.Common.DAL.DataObjects;
using TestingSystem.Common.DAL.DataServices;

namespace TestingSystem.Common.DAL.Infrastructure
{
   public sealed class ContainerModule : BaseContainerModule
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
            InjectDataService(builder, typeof(BaseDatabaseDataService<GroupTest>), typeof(IDataService<GroupTest>), new BaseDataServiceInitializer<GroupTest>
            {
                TypeTools = new TypeTools<GroupTest>
                {
                    FirstKeyAttribute = new EntityKeyAttribute
                    {
                        PropertyName = "RecordId"
                    }
                }
            });

            // Question.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Question>), typeof(IDataService<Question>), new BaseDataServiceInitializer<Question>
            {
                TypeTools = new TypeTools<Question>
                {
                    FirstKeyAttribute = new EntityKeyAttribute
                    {
                        PropertyName = "QuestionId"
                    }
                }
            });

            // Role.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Role>), typeof(IDataService<Role>));

            // Student Test.
            InjectDataService(builder, typeof(BaseDatabaseDataService<StudentTest>), typeof(IDataService<StudentTest>), new BaseDataServiceInitializer<StudentTest>
            {
                TypeTools = new TypeTools<StudentTest>
                {
                    FirstKeyAttribute = new EntityKeyAttribute
                    {
                        PropertyName = "RecordId"
                    }
                }
            });

            // Test.
            InjectDataService(builder, typeof(BaseDatabaseDataService<Test>), typeof(IDataService<Test>));

            // User.
            InjectDataService(builder, typeof(BaseDatabaseDataService<User>), typeof(IDataService<User>));

            // User Role.
            InjectDataService(builder, typeof(BaseDatabaseDataService<UserRole>), typeof(IDataService<UserRole>), new BaseDataServiceInitializer<UserRole>
            {
                TypeTools = new TypeTools<UserRole>
                {
                    FirstKeyAttribute = new EntityKeyAttribute
                    {
                        PropertyName = "UserId"
                    },
                    SecondKeyAttribute = new EntityKeyAttribute
                    {
                        PropertyName = "RoleId"
                    }
                }
            });

            #endregion
        }
    }
}
