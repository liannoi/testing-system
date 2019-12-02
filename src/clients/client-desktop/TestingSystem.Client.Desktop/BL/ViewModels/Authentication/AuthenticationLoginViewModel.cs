// Copyright 2019 Maksym Liannoi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using System.Threading.Tasks;
using System.Windows.Input;
using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Events;
using Multilayer.BusinessServices;
using TestingSystem.Client.Desktop.BL.BusinessServices.Windows.SuggestedRole;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authentication;
using TestingSystem.Common.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.Infrastructure.Container;
using TestingSystem.Common.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Authentication
{
    public sealed class AuthenticationLoginViewModel : BaseViewModel
    {
        #region Constructors

        public AuthenticationLoginViewModel()
        {
            InitializeContainers();
            InitializeServices();
            InitializeValidators();
            AllowUseComponents();
        }

        #endregion

        #region Commands

        public ICommand SignInCommand => MakeCommand(async a => await SignInAsync(),
            c => passwordValidator.IsValid(Password) && loginValidator.IsValid(Login));

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

            NotifyOnUiUnfrozen();
            ClearFields();
            OpenSuggestWindow(findUser, userRole);
        }

        #endregion

        #region Events

        protected override void OnUiBusy(UiBusyEventArgs e)
        {
            CanUseComponents = false;
            base.OnUiBusy(e);
        }

        protected override void OnUiUnfrozen(UiUnfrozenEventArgs e)
        {
            AllowUseComponents();
            base.OnUiUnfrozen(e);
        }

        #endregion

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

        #region Helpers

        private void OpenSuggestWindow(UserBusinessObject findUser, UserRoleBusinessObject userRole)
        {
            windowManager.User = findUser;
            windowManager.Role = (AuthorizationRole) userRole.RoleId;
            windowManager.OpenSuggestWindow();
        }

        private async Task<UserRoleBusinessObject> Authorization(UserBusinessObject findUser)
        {
            authorizationService.AuthorizationRole = AuthorizationRole + 1;
            authorizationService.User = findUser;
            return await authorizationService.CheckUserPermission();
        }

        private async Task<UserBusinessObject> Authentication()
        {
            NotifyOnUiBusy("Sign in. Login to the system. Search for matches with the entered data in the database");
            UpdateSearchData();
            return await TryFindUserAsync();
        }

        private async Task<UserBusinessObject> TryFindUserAsync()
        {
            return await authenticationService.SignInAsync();
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