using Multilayer.BusinessServices;
using System.Linq;
using System.Threading.Tasks;
using TestingSystem.Client.Desktop.BL.Helpers;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Authentication
{
    public class AuthenticationService : IAuthenticationService
    {
        private readonly IBusinessService<UserBusinessObject> usersBusinessService;
        private readonly IBusinessService<UserRoleBusinessObject> usersRolesBusinessService;

        public string Login { get; set; }
        public string Password { get; set; }
        public int RoleId { get; set; }

        public AuthenticationService(IBusinessService<UserBusinessObject> usersBusinessService, IBusinessService<UserRoleBusinessObject> usersRolesBusinessService)
        {
            this.usersBusinessService = usersBusinessService;
            this.usersRolesBusinessService = usersRolesBusinessService;
        }

        public async Task<bool> HavePermissonAsync(UserBusinessObject user)
        {
            if (user == null)
            {
                return false;
            }
            return await Task.Factory.StartNew(() =>
            {
                return usersRolesBusinessService.Find(e => e.UserId == user.UserId && e.RoleId == RoleId).FirstOrDefault() == null ? throw new NoPermissionException() : true;
            });
        }

        public async Task<UserBusinessObject> SignInAsync()
        {
            return await Task.Factory.StartNew(() =>
            {
                Password = DataTools.ToMd5Hash(Password);
                return usersBusinessService.Find(e => e.Password == Password && e.Login == Login).FirstOrDefault() ?? throw new InvalidAuthenticationException();
            });
        }
    }
}
