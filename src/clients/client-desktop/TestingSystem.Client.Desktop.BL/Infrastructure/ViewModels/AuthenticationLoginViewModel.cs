using Client.Desktop.BL.Infrastructure;
using System.Windows;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels
{
    public sealed class AuthenticationLoginViewModel : BaseViewModel
    {
        private readonly StringValidator loginValidator;
        private readonly StringValidator passwordValidator;

        public string Login
        {
            get => Get<string>();
            set => Set(value);
        }

        public string Password
        {
            get => Get<string>();
            set => Set(value);
        }

        public ICommand SignInCommand => MakeCommand(a => MessageBox.Show("Ready to sign in ..."), c => passwordValidator.IsValid(Password) && loginValidator.IsValid(Login));

        public AuthenticationLoginViewModel()
        {
            loginValidator = new StringValidator(8, 128);
            passwordValidator = new StringValidator(5, 128);
        }
    }
}
