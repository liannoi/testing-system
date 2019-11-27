using TestingSystem.Client.Desktop.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.SuggestedRole
{
    public interface ISuggestedRoleWindowManagementService
    {
        AuthorizationRole Role { get; set; }
        UserBusinessObject User { get; set; }

        void OpenSuggestWindow();
    }
}