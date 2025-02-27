﻿// Copyright 2020 Maksym Liannoi
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

using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Events;
using System.Threading.Tasks;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.Container;
using TestingSystem.Client.Desktop.BL.WindowManagement.SuggestedRole;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authentication;
using TestingSystem.Common.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Authentication
{
    public sealed class AuthenticationLoginViewModel : BaseViewModel
    {
        private readonly ContainerConfig container;
        private IAuthenticationService authenticationService;
        private IAuthorizationService authorizationService;
        private ILoginValidator loginValidator;
        private IPasswordValidator passwordValidator;
        private ISuggestedRoleWindowManagementService windowManager;

        public AuthenticationLoginViewModel()
        {
            container = new ContainerConfig();
            ResolveServices();
            ResolveValidators();
            AllowUseComponents();
        }

        public ICommand SignInCommand => MakeCommand(async a => await SignInAsync(),
            c => passwordValidator.IsValid(Password) && loginValidator.IsValid(Login));

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

        private void ResolveValidators()
        {
            loginValidator = container.Container.Resolve<ILoginValidator>();
            passwordValidator = container.Container.Resolve<IPasswordValidator>();
        }

        private void ResolveServices()
        {
            authenticationService = container.Container.Resolve<IAuthenticationService>();
            authorizationService = container.Container.Resolve<IAuthorizationService>();
            windowManager = container.Container.Resolve<ISuggestedRoleWindowManagementService>();
        }
    }
}