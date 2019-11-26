using Multilayer.BusinessServices;
using System;
using System.Linq;
using System.Threading.Tasks;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authentication;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Authorization
{
    public class AuthorizationService : IAuthorizationService
    {
        public IBusinessService<UserRoleBusinessObject> UsersRolesBusinessService { get; set; }
        public UserBusinessObject User { get; set; }
        public AuthorizationRole AuthorizationRole { get; set; }

        public async Task<UserRoleBusinessObject> CheckUserPermission()
        {
            if (User == null)
            {
                throw new ArgumentNullException();
            }
            return await Task.Factory.StartNew(() =>
            {
                return UsersRolesBusinessService.Find(e => e.UserId == User.UserId && e.RoleId == (int)AuthorizationRole).FirstOrDefault() ?? throw new InvalidAuthorizationException();
            });
        }
    }
}
