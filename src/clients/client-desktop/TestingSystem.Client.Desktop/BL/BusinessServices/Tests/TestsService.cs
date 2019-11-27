using Multilayer.BusinessServices;
using System;
using System.Collections.Generic;
using System.Linq;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Tests
{
    public class TestsService : ITestsService
    {
        private readonly IBusinessService<TestBusinessObject> testsBusinessService;
        private readonly IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService;
        private readonly UserBusinessObject user;

        public IEnumerable<TestBusinessObject> Tests
        {
            get
            {
                foreach (StudentTestBusinessObject test in TestsByUser)
                {
                    yield return testsBusinessService.Find(e => e.TestId == test.TestId).Where(e => e.IsRemoved == false).FirstOrDefault();
                }
            }
        }

        public double AverageGrade
        {
            get
            {
                return StudentTests().Select(e => e.PCA / 100 * 12).Average() ?? 0;
            }
        }

        private IEnumerable<StudentTestBusinessObject> TestsByUser
        {
            get
            {
                if (user == null)
                {
                    throw new ArgumentNullException();
                }
                yield return StudentTests().Where(e => e.IsRemoved == false).FirstOrDefault();
            }
        }

        public TestsService(IBusinessService<TestBusinessObject> testsBusinessService, IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService, UserBusinessObject user)
        {
            this.testsBusinessService = testsBusinessService;
            this.studentsTestsBusinessService = studentsTestsBusinessService;
            this.user = user;
        }

        private IEnumerable<StudentTestBusinessObject> StudentTests()
        {
            return studentsTestsBusinessService.Find(e => e.UserId == user.UserId).Where(e => e.IsRemoved == false);
        }
    }
}
