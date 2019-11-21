using AutoMapper;

namespace TestingSystem.Common.BL.Infrastructure
{
    public class BusinessServiceInitializer
    {
        public string ParameterName { get; set; } = "mapper";

        public IMapper MapperConfiguration { get; set; }
    }
}
