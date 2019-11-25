using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Events;
using Multilayer.BusinessServices;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authentication;
using TestingSystem.Client.Desktop.BL.Infrastructure.Validators;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.Infrastructure;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels
{
    public sealed class AuthenticationLoginViewModel : BaseViewModel
    {
        private ContainerConfig businessLogicContainer;
        private Container.ContainerConfig clientContainer;
        private IAuthenticationService authenticationService;
        private IBusinessService<UserBusinessObject> users;
        private IBusinessService<UserRoleBusinessObject> usersRoles;
        private ILoginValidator loginValidator;
        private IPasswordValidator passwordValidator;

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

        public AuthenticationRole AuthenticationRole
        {
            get => Get<AuthenticationRole>();
            set => Set(value);
        }

        public bool CanUseComponents
        {
            get => Get<bool>();
            set => Set(value);
        }

        public ICommand SignInCommand => MakeCommand(async a => await SignInAsync(), c => passwordValidator.IsValid(Password) && loginValidator.IsValid(Login));

        public AuthenticationLoginViewModel()
        {
            InitializeContainers();
            InitializeServices();
            InitializeValidators();
            AllowUseComponents();
        }

        private async Task SignInAsync()
        {
            NotifyOnUIBusy("Sign in. Login to the system. Search for matches with the entered data in the database");
            UpdateSearchData();
            UserBusinessObject find;

            try
            {
                find = await TryFindUserAsync();
            }
            catch (InvalidAuthenticationException)
            {
                return;
            }

            try
            {
                await CheckUserPermission(find);
            }
            catch (NoPermissionException)
            {
                return;
            }

            NotifyOnUIUnfrozen();
            ClearFields();
        }

        #region Events

        protected override void OnUIBusy(UIBusyEventArgs e)
        {
            CanUseComponents = false;
            base.OnUIBusy(e);
        }

        protected override void OnUIUnfrozen(UIUnfrozenEventArgs e)
        {
            AllowUseComponents();
            base.OnUIUnfrozen(e);
        }

        #endregion

        #region Helpers

        private async Task<UserBusinessObject> TryFindUserAsync()
        {
            try
            {
                return await authenticationService.SignInAsync();
            }
            catch (InvalidAuthenticationException e)
            {
                MessageBox.Show(e.Message);
                NotifyOnUIUnfrozen(e);
                throw;
            }
        }

        private async Task CheckUserPermission(UserBusinessObject find)
        {
            try
            {
                await authenticationService.HavePermissonAsync(find);
            }
            catch (NoPermissionException e)
            {
                MessageBox.Show(e.Message);
                NotifyOnUIUnfrozen(e);
                throw;
            }
        }

        private void InitializeValidators()
        {
            loginValidator = clientContainer.Container.Resolve<ILoginValidator>();
            passwordValidator = clientContainer.Container.Resolve<IPasswordValidator>();
        }

        private void InitializeServices()
        {
            users = businessLogicContainer.Container.Resolve<IBusinessService<UserBusinessObject>>();
            usersRoles = businessLogicContainer.Container.Resolve<IBusinessService<UserRoleBusinessObject>>();
            authenticationService = new AuthenticationService(users, usersRoles);
        }

        private void AllowUseComponents()
        {
            CanUseComponents = true;
        }

        private void InitializeContainers()
        {
            businessLogicContainer = new ContainerConfig();
            clientContainer = new Container.ContainerConfig();
        }

        private void ClearFields()
        {
            Password = string.Empty;
            Login = string.Empty;
        }

        private void UpdateSearchData()
        {
            authenticationService.Password = Password;
            authenticationService.Login = Login;
            authenticationService.RoleId = (int)AuthenticationRole + 1;
        }

        #endregion
    }
}
