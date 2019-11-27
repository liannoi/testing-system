using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Events;
using Multilayer.BusinessServices;
using System.Threading.Tasks;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authentication;
using TestingSystem.Client.Desktop.BL.BusinessServices.Authorization;
using TestingSystem.Client.Desktop.BL.BusinessServices.Windows.SuggestedRole;
using TestingSystem.Client.Desktop.BL.Infrastructure.Validators;
using TestingSystem.Client.Desktop.UI.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.Infrastructure;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels.Authentication
{
    public sealed class AuthenticationLoginViewModel : BaseViewModel
    {
        #region Fields

        #region Containers

        private ContainerConfig businessLogicContainer;
        private Container.ContainerConfig clientContainer;

        #endregion

        #region Services

        private IAuthenticationService authenticationService;
        private IAuthorizationService authorizationService;
        private IBusinessService<UserBusinessObject> users;
        private IBusinessService<UserRoleBusinessObject> usersRoles;
        private ISuggestedRoleWindowManagementService windowManager;

        #endregion

        #region Validators

        private ILoginValidator loginValidator;
        private IPasswordValidator passwordValidator;

        #endregion

        #endregion

        #region Properties

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

        public AuthorizationRole AuthorizationRole
        {
            get => Get<AuthorizationRole>();
            set => Set(value);
        }

        public bool CanUseComponents
        {
            get => Get<bool>();
            set => Set(value);
        }

        #endregion

        #region Commands

        public ICommand SignInCommand => MakeCommand(async a => await SignInAsync(), c => passwordValidator.IsValid(Password) && loginValidator.IsValid(Login));

        #endregion

        #region Constructors

        public AuthenticationLoginViewModel()
        {
            InitializeContainers();
            InitializeServices();
            InitializeValidators();
            AllowUseComponents();
        }

        #endregion

        #region Commands implementation

        private async Task SignInAsync()
        {
            UserBusinessObject findUser;
            try
            {
                findUser = await Authentication();
            }
            catch (InvalidAuthenticationException e)
            {
                DefaultProcessException(e);
                return;
            }
            UserRoleBusinessObject userRole;
            try
            {
                userRole = await Authorization(findUser);
            }
            catch (InvalidAuthorizationException e)
            {
                DefaultProcessException(e);
                return;
            }
            NotifyOnUIUnfrozen();
            ClearFields();
            OpenSuggestWindow(findUser, userRole);
        }

        #endregion

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

        private void OpenSuggestWindow(UserBusinessObject findUser, UserRoleBusinessObject userRole)
        {
            windowManager.User = findUser;
            windowManager.Role = (AuthorizationRole)userRole.RoleId;
            windowManager.OpenSuggestWindow();
        }

        private async Task<UserRoleBusinessObject> Authorization(UserBusinessObject findUser)
        {
            authorizationService.AuthorizationRole = AuthorizationRole + 1;
            authorizationService.User = findUser;
            try
            {
                return await authorizationService.CheckUserPermission();
            }
            catch (InvalidAuthorizationException)
            {
                throw;
            }
        }

        private async Task<UserBusinessObject> Authentication()
        {
            NotifyOnUIBusy("Sign in. Login to the system. Search for matches with the entered data in the database");
            UpdateSearchData();
            try
            {
                return await TryFindUserAsync();
            }
            catch (InvalidAuthenticationException)
            {
                throw;
            }
        }

        private async Task<UserBusinessObject> TryFindUserAsync()
        {
            try
            {
                return await authenticationService.SignInAsync();
            }
            catch (InvalidAuthenticationException)
            {
                throw;
            }
        }

        private void AllowUseComponents()
        {
            CanUseComponents = true;
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
        }

        #endregion

        #region Initializers

        private void InitializeValidators()
        {
            loginValidator = clientContainer.Container.Resolve<ILoginValidator>();
            passwordValidator = clientContainer.Container.Resolve<IPasswordValidator>();
        }

        private void InitializeServices()
        {
            users = businessLogicContainer.Container.Resolve<IBusinessService<UserBusinessObject>>();
            usersRoles = businessLogicContainer.Container.Resolve<IBusinessService<UserRoleBusinessObject>>();
            authenticationService = new AuthenticationService(users);
            authorizationService = new AuthorizationService
            {
                UsersRolesBusinessService = usersRoles
            };
            windowManager = new SuggestedRoleWindowManagementService();
        }

        private void InitializeContainers()
        {
            businessLogicContainer = new ContainerConfig();
            clientContainer = new Container.ContainerConfig();
        }

        #endregion
    }
}
