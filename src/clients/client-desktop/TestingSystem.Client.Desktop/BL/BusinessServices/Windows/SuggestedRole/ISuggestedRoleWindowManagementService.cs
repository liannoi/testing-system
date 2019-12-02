using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authorization;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.SuggestedRole
{
    public interface ISuggestedRoleWindowManagementService
    {
        AuthorizationRole Role { get; set; }
        UserBusinessObject User { get; set; }

        void OpenSuggestWindow();
    }
}