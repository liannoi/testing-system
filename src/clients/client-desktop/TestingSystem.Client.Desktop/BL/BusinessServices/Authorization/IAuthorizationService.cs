using Multilayer.BusinessServices;
using System.Threading.Tasks;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Authorization
{
    public interface IAuthorizationService
    {
        AuthorizationRole AuthorizationRole { get; set; }
        UserBusinessObject User { get; set; }
        IBusinessService<UserRoleBusinessObject> UsersRolesBusinessService { get; set; }

        Task<UserRoleBusinessObject> CheckUserPermission();
    }
}