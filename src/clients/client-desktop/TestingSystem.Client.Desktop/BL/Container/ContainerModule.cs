// Copyright 2020 Maksym Liannoi
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
using Multilayer.BusinessServices;
using System;
using TestingSystem.Client.Desktop.BL.WindowManagement.PassingTest;
using TestingSystem.Client.Desktop.BL.WindowManagement.PassingTest.End;
using TestingSystem.Client.Desktop.BL.WindowManagement.SuggestedRole;
using TestingSystem.Client.Desktop.BL.WindowManagement.TestDetails;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authentication;
using TestingSystem.Common.BL.BusinessServices.Authorization;
using TestingSystem.Common.BL.BusinessServices.Tests;
using TestingSystem.Common.BL.BusinessServices.Tests.Passing;
using TestingSystem.Common.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.Container
{
    public sealed class ContainerModule : Module
    {
        private readonly Common.BL.Infrastructure.Container.ContainerConfig businessLogicContainer;

        public ContainerModule()
        {
            businessLogicContainer = new Common.BL.Infrastructure.Container.ContainerConfig();
        }

        protected override void Load(ContainerBuilder builder)
        {
            // LoginValidator.
            Inject(builder, typeof(LoginValidator), typeof(ILoginValidator), "validatorParameter",
                new StringValidatorParameter
                {
                    MinLength = 8,
                    MaxLength = 128
                });

            // PasswordValidator.
            Inject(builder, typeof(PasswordValidator), typeof(IPasswordValidator), "validatorParameter",
                new StringValidatorParameter
                {
                    MinLength = 5,
                    MaxLength = 128
                });

            // StringValidatorParameter.
            Inject(builder, typeof(StringValidatorParameter), typeof(IStringValidatorParameter));

            // AuthenticationService.
            Inject(builder, typeof(AuthenticationService), typeof(IAuthenticationService), "usersBusinessService",
                businessLogicContainer.Container.Resolve<IBusinessService<UserBusinessObject>>());

            // AuthorizationService.
            Inject(builder, typeof(AuthorizationService), typeof(IAuthorizationService), "usersRolesBusinessService",
                businessLogicContainer.Container.Resolve<IBusinessService<UserRoleBusinessObject>>());

            // SuggestedRoleWindowManagementService.
            Inject(builder, typeof(SuggestedRoleWindowManagementService), typeof(ISuggestedRoleWindowManagementService));

            // StudentTestsService.
            Inject(builder, typeof(StudentTestsService), typeof(IStudentTestsService), "studentsTestsBusinessService", businessLogicContainer.Container.Resolve<IBusinessService<StudentTestBusinessObject>>());

            // TestDetailsWindowManagementService.
            Inject(builder, typeof(TestDetailsWindowManagementService), typeof(ITestDetailsWindowManagementService));

            // EndPassingTestWindowManagementService.
            Inject(builder, typeof(EndPassingTestWindowManagementService), typeof(IEndPassingTestWindowManagementService));

            // PassingTestWindowManagementService.
            Inject(builder, typeof(PassingTestWindowManagementService), typeof(IPassingTestWindowManagementService));

            // PassingTestService.
            builder.RegisterType(typeof(PassingTestService))
                .As(typeof(IPassingTestService))
                .WithParameter("questions", businessLogicContainer.Container.Resolve<IBusinessService<QuestionBusinessObject>>())
                .WithParameter("answers", businessLogicContainer.Container.Resolve<IBusinessService<AnswerBusinessObject>>())
                .WithParameter("studentTests", businessLogicContainer.Container.Resolve<IBusinessService<StudentTestBusinessObject>>());
        }

        private void Inject<TParam>(ContainerBuilder builder, Type registerType, Type asType, string parameterName,
            TParam parameter)
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(parameterName, parameter);
        }

        private void Inject(ContainerBuilder builder, Type registerType, Type asType)
        {
            builder.RegisterType(registerType)
                .As(asType);
        }
    }
}