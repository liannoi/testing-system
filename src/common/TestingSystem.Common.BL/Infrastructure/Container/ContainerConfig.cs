using Autofac;

namespace TestingSystem.Common.BL.Infrastructure.Container
{
    public sealed class ContainerConfig
    {
        public ContainerConfig()
        {
            Container = Build();
        }

        public IContainer Container { get; }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private IContainer Build()
        {
            var builder = new ContainerBuilder();
            builder.RegisterModule<ContainerModule>();
            return builder.Build();
        }
    }
}