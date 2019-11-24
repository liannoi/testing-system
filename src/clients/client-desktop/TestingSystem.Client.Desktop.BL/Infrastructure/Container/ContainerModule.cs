using Autofac;
using TestingSystem.Client.Desktop.BL.Infrastructure.Validators;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.Container
{
    public sealed class ContainerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType(typeof(LoginValidator))
                .As(typeof(ILoginValidator))
                .WithParameter("validatorParameter", new StringValidatorParameter
                {
                    MinLength = 8,
                    MaxLength = 128
                });

            builder.RegisterType(typeof(PasswordValidator))
                .As(typeof(IPasswordValidator))
                .WithParameter("validatorParameter", new StringValidatorParameter
                {
                    MinLength = 5,
                    MaxLength = 128
                });

            builder.RegisterType(typeof(StringValidatorParameter))
                .As(typeof(IStringValidatorParameter));
        }
    }
}