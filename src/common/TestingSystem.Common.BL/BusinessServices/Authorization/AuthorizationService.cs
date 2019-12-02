using System;
using System.Linq;
using System.Threading.Tasks;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authentication;

namespace TestingSystem.Common.BL.BusinessServices.Authorization
{
    public class AuthorizationService : IAuthorizationService
    {
        public IBusinessService<UserRoleBusinessObject> UsersRolesBusinessService { get; set; }
        public UserBusinessObject User { get; set; }
        public AuthorizationRole AuthorizationRole { get; set; }

        public async Task<UserRoleBusinessObject> CheckUserPermission()
        {
            if (User == null) throw new ArgumentNullException();
            return await Task.Factory.StartNew(() =>
            {
                return UsersRolesBusinessService
                           .Find(e => e.UserId == User.UserId && e.RoleId == (int) AuthorizationRole)
                           .FirstOrDefault() ?? throw new InvalidAuthorizationException();
            });
        }
    }
}