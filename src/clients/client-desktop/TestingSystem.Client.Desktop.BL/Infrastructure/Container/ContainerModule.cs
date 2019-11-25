using Autofac;
using System;
using TestingSystem.Client.Desktop.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.Container
{
    public sealed class ContainerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            Inject(builder, typeof(LoginValidator), typeof(ILoginValidator), "validatorParameter", new StringValidatorParameter
            {
                MinLength = 8,
                MaxLength = 128
            });

            Inject(builder, typeof(PasswordValidator), typeof(IPasswordValidator), "validatorParameter", new StringValidatorParameter
            {
                MinLength = 5,
                MaxLength = 128
            });

            Inject(builder, typeof(StringValidatorParameter), typeof(IStringValidatorParameter));
        }

        private void Inject(ContainerBuilder builder,Type registerType, Type asType, string parameterName, IStringValidatorParameter parameter)
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