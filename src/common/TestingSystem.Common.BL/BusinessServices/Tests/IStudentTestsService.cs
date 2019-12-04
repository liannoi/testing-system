using System.Collections.Generic;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Tests
{
    public interface IStudentTestsService
    {
        float AverageGrade { get; }
        IEnumerable<StudentTestBusinessObject> Tests { get; }
    }
}