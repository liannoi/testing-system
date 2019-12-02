namespace Multilayer.Infrastructure.Keys
{
    public sealed class EntityKeyAttribute : IEntityKeyAttribute
    {
        public string PropertyName { get; set; }
    }
}