using System.Linq;
using System.Threading.Tasks;
using Client.Desktop.BL.Infrastructure.Helpers;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Authentication
{
    public class AuthenticationService : IAuthenticationService
    {
        private readonly IBusinessService<UserBusinessObject> usersBusinessService;

        public AuthenticationService(IBusinessService<UserBusinessObject> usersBusinessService)
        {
            this.usersBusinessService = usersBusinessService;
        }

        public string Login { get; set; }
        public string Password { get; set; }

        public async Task<UserBusinessObject> SignInAsync()
        {
            return await Task.Factory.StartNew(() =>
            {
                Password = Md5DataTools.ToMd5Hash(Password);
                return usersBusinessService.Find(e => e.Password == Password && e.Login == Login).FirstOrDefault() ??
                       throw new InvalidAuthenticationException();
            });
        }
    }
}