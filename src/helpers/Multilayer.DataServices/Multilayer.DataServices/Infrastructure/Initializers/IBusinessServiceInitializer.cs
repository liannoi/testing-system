using AutoMapper;

namespace Multilayer.Infrastructure.Initializers
{
    public interface IBusinessServiceInitializer
    {
        IMapper MapperConfiguration { get; set; }
        string ParameterName { get; set; }
    }
}