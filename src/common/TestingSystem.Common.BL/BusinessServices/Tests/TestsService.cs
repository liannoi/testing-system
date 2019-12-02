using System;
using System.Collections.Generic;
using System.Linq;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Tests
{
    public class TestsService : ITestsService
    {
        private readonly IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService;
        private readonly IBusinessService<TestBusinessObject> testsBusinessService;
        private readonly UserBusinessObject user;

        public TestsService(IBusinessService<TestBusinessObject> testsBusinessService,
            IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService, UserBusinessObject user)
        {
            this.testsBusinessService = testsBusinessService;
            this.studentsTestsBusinessService = studentsTestsBusinessService;
            this.user = user;
        }

        private IEnumerable<StudentTestBusinessObject> TestsByUser
        {
            get
            {
                if (user == null) throw new ArgumentNullException();
                yield return StudentTests().Where(e => e.IsRemoved == false).FirstOrDefault();
            }
        }

        public IEnumerable<TestBusinessObject> Tests
        {
            get
            {
                foreach (var test in TestsByUser)
                    yield return testsBusinessService.Find(e => e.TestId == test.TestId)
                        .Where(e => e.IsRemoved == false).FirstOrDefault();
            }
        }

        public double AverageGrade => StudentTests().Select(e => e.PCA / 100 * 12).Average() ?? 0;

        private IEnumerable<StudentTestBusinessObject> StudentTests()
        {
            return studentsTestsBusinessService.Find(e => e.UserId == user.UserId).Where(e => e.IsRemoved == false);
        }
    }
}