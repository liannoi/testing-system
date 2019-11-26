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

        public TestsService(IBusinessService<TestBusinessObject> testsBusinessService, IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService, UserBusinessObject user)
        {
            this.testsBusinessService = testsBusinessService;
            this.studentsTestsBusinessService = studentsTestsBusinessService;
            this.user = user;
        }
    }
}
