using System;
using Client.Desktop.BL.Infrastructure.Windows;
using TestingSystem.Client.Desktop.BL.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authorization;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.SuggestedRole
{
    public class SuggestedRoleWindowManagementService : ISuggestedRoleWindowManagementService
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
                    strategy = new WindowsManagementStrategy<StudentDashboardViewModel, StudentDashboard>(
                        new StudentDashboardViewModel(User),
                        new StudentDashboard());
                    strategy.Open();
                    strategy.CloseParent();
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