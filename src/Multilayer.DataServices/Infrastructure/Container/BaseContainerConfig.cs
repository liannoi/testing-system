using Autofac;
using Autofac.Core.Registration;

namespace Multilayer.Infrastructure.Contrainer
{
    public abstract class BaseContainerConfig : IContainerConfig
    {
        public IContainer Container { get; protected set; }

        public abstract IContainer Build();
    }
}
