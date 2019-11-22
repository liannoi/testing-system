using Autofac;
using Autofac.Core.Registration;

namespace Multilayer.Infrastructure.Contrainer
{
    public interface IContainerConfig
    {
        IContainer Container { get; }

        IContainer Build();
    }
}