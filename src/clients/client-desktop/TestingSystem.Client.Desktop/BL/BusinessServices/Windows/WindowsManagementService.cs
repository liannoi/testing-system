using System;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authorization;
using TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.Strategy;
using TestingSystem.Client.Desktop.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows
{
    public class WindowsManagementService : IWindowsManagementService
    {
        private IWindowsManagementStrategy strategy;

        public UserBusinessObject User { get; set; }
        public AuthorizationRole Role { get; set; }

        public void OpenSuggestWindow()
        {
            switch (Role)
            {
                case AuthorizationRole.Student:
                    {
                        strategy = new WindowsManagementStrategy<StudentDashboardViewModel, StudentDashboard>(new StudentDashboardViewModel(User), new StudentDashboard());
                        strategy.Open();
                        break;
                    }
                case AuthorizationRole.Teacher:
                    {
                        throw new NotSupportedException("This method isn't implemented.");
                    }
                case AuthorizationRole.Administrator:
                    {
                        throw new NotSupportedException("This method isn't implemented.");
                    }
            }
        }
    }
}
