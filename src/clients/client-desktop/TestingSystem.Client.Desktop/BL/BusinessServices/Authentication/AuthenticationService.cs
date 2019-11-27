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

        public string Login { get; set; }
        public string Password { get; set; }

        public AuthenticationService(IBusinessService<UserBusinessObject> usersBusinessService)
        {
            this.usersBusinessService = usersBusinessService;
        }

        public async Task<UserBusinessObject> SignInAsync()
        {
            return await Task.Factory.StartNew(() =>
            {
                Password = Md5DataTools.ToMd5Hash(Password);
                return usersBusinessService.Find(e => e.Password == Password && e.Login == Login).FirstOrDefault() ?? throw new InvalidAuthenticationException();
            });
        }
    }
}
