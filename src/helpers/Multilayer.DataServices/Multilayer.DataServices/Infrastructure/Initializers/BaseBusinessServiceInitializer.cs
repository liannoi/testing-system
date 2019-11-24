using AutoMapper;

namespace Multilayer.Infrastructure.Initializers
{
    public class BaseBusinessServiceInitializer : IBusinessServiceInitializer
    {
        public string ParameterName { get; set; } = "mapper";

        public IMapper MapperConfiguration { get; set; }
    }
}
