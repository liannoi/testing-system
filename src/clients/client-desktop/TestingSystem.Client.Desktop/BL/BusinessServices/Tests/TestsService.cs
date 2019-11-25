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

        public TestsService(IBusinessService<TestBusinessObject> testsBusinessService, IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService)
        {
            this.testsBusinessService = testsBusinessService;
            this.studentsTestsBusinessService = studentsTestsBusinessService;
        }

        public IEnumerable<TestBusinessObject> Tests(UserBusinessObject user)
        {
            if (user == null)
            {
                throw new ArgumentNullException();
            }
            IEnumerable<StudentTestBusinessObject> testsByUser = studentsTestsBusinessService.Find(e => e.UserId == user.UserId);
            foreach (StudentTestBusinessObject test in testsByUser)
            {
                yield return testsBusinessService.Find(e => e.TestId == test.TestId).FirstOrDefault();
            }
        }
    }
}
