using TestingSystem.DAL.DataObjects;
using TestingSystem.DAL.DataObjects.Context;
using TestingSystem.DAL.DataServices.Database.Infrastructure;

namespace TestingSystem.DAL.DataServices
{
    public class DatabaseDataServices
    {
        private readonly BaseContext context;
        private BaseDatabaseDataService<Answer> answers;
        private BaseDatabaseDataService<Group> groups;
        private BaseDatabaseDataService<Question> questions;
        private BaseDatabaseDataService<Role> roles;
        private BaseDatabaseDataService<StudentTest> studentTests;
        private BaseDatabaseDataService<Test> tests;
        private BaseDatabaseDataService<User> users;

        public IDatabaseDataService<Answer> Answers => answers ?? (answers = new BaseDatabaseDataService<Answer>(context));
        public IDatabaseDataService<Group> Groups => groups ?? (groups = new BaseDatabaseDataService<Group>(context));
        public IDatabaseDataService<Question> Questions => questions ?? (questions = new BaseDatabaseDataService<Question>(context));
        public IDatabaseDataService<Role> Roles => roles ?? (roles = new BaseDatabaseDataService<Role>(context));
        public IDatabaseDataService<StudentTest> StudentTests => studentTests ?? (studentTests = new BaseDatabaseDataService<StudentTest>(context));
        public IDatabaseDataService<Test> Tests => tests ?? (tests = new BaseDatabaseDataService<Test>(context));
        public IDatabaseDataService<User> Users => users ?? (users = new BaseDatabaseDataService<User>(context));

        public DatabaseDataServices(BaseContext context)
        {
            this.context = context;
        }

        public int Commit()
        {
            return context.SaveChanges();
        }
    }
}
