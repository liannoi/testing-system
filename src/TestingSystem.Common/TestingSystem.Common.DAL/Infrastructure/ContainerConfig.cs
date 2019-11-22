using Autofac;
using Multilayer.Infrastructure.Contrainer;

namespace TestingSystem.Common.DAL.Infrastructure
{
    public sealed class ContainerConfig : BaseContainerConfig
    {
        public ContainerConfig()
        {
            Container = Build();
        }

        public override IContainer Build()
        {
            ContainerBuilder builder = new ContainerBuilder();
            builder.RegisterModule<ContainerModule>();
            return builder.Build();
        }
    }
}
