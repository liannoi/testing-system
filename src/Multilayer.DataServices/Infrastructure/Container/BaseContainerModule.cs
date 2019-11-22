using Autofac;
using Multilayer.Infrastructure.Initializers;
using System;

namespace Multilayer.Infrastructure.Contrainer
{
    public class BaseContainerModule : Module, IContainerModule
    {
        public void InjectDataService(ContainerBuilder builder, Type registerType, Type asType)
        {
            builder.RegisterType(registerType)
                .As(asType);
        }

        public void InjectDataService<TEntity>(ContainerBuilder builder, Type registerType, Type asType, IDataServiceInitializer<TEntity> dataServiceInitializer) where TEntity : class, new()
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(dataServiceInitializer.ParameterName, dataServiceInitializer.TypeTools);
        }

        public void InjectBusinessService(ContainerBuilder builder, Type registerType, Type asType, IBusinessServiceInitializer businessServiceInitializer)
        {
            builder.RegisterType(registerType)
                .As(asType)
                .WithParameter(businessServiceInitializer.ParameterName, businessServiceInitializer.MapperConfiguration);
        }
    }
}
