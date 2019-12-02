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

using System;
using Autofac;
using TestingSystem.Common.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.Container
{
    public sealed class ContainerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            Inject(builder, typeof(LoginValidator), typeof(ILoginValidator), "validatorParameter",
                new StringValidatorParameter
                {
                    MinLength = 8,
                    MaxLength = 128
                });

            Inject(builder, typeof(PasswordValidator), typeof(IPasswordValidator), "validatorParameter",
                new StringValidatorParameter
                {
                    MinLength = 5,
                    MaxLength = 128
                });

            Inject(builder, typeof(StringValidatorParameter), typeof(IStringValidatorParameter));
        }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private void Inject(ContainerBuilder builder, Type registerType, Type asType, string parameterName,
            IStringValidatorParameter parameter)
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(parameterName, parameter);
        }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private void Inject(ContainerBuilder builder, Type registerType, Type asType)
        {
            builder.RegisterType(registerType)
                .As(asType);
        }
    }
}