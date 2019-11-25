using Autofac;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.Container
{
    public sealed class ContainerConfig
    {
        public IContainer Container { get; private set; }

        public ContainerConfig()
        {
            Container = Build();
        }

        private IContainer Build()
        {
            ContainerBuilder builder = new ContainerBuilder();
            builder.RegisterModule<ContainerModule>();
            return builder.Build();
        }
    }
}
