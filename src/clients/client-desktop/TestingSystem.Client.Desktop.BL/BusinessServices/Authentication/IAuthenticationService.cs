using System.Threading.Tasks;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Authentication
{
    public interface IAuthenticationService
    {
        string Login { get; set; }
        string Password { get; set; }
        int RoleId { get; set; }

        Task<UserBusinessObject> SignInAsync();
        Task HavePermissonAsync(UserBusinessObject user);
    }
}