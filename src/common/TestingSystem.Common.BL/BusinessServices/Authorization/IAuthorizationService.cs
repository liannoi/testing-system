using System.Threading.Tasks;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Authorization
{
    public interface IAuthorizationService
    {
        AuthorizationRole AuthorizationRole { get; set; }
        UserBusinessObject User { get; set; }
        IBusinessService<UserRoleBusinessObject> UsersRolesBusinessService { get; set; }

        Task<UserRoleBusinessObject> CheckUserPermission();
    }
}