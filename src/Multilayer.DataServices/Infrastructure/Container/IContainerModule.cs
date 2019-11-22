using System;
using Autofac;
using Multilayer.Infrastructure.Initializers;

namespace Multilayer.Infrastructure.Contrainer
{
    public interface IContainerModule
    {
        void InjectBusinessService(ContainerBuilder builder, Type registerType, Type asType, IBusinessServiceInitializer businessServiceInitializer);
        void InjectDataService(ContainerBuilder builder, Type registerType, Type asType);
        void InjectDataService<TEntity>(ContainerBuilder builder, Type registerType, Type asType, IDataServiceInitializer<TEntity> dataServiceInitializer) where TEntity : class, new();
    }
}