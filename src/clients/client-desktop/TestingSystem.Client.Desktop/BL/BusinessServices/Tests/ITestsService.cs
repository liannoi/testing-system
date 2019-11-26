using System.Collections.Generic;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Tests
{
    public interface ITestsService
    {
        IEnumerable<TestBusinessObject> Tests { get; }
    }
}