using System.Threading.Tasks;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Authentication
{
    public interface IAuthenticationService
    {
        string Login { get; set; }
        string Password { get; set; }

        Task<UserBusinessObject> SignInAsync();
    }
}