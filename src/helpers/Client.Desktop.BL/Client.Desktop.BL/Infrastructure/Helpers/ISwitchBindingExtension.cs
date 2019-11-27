namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public interface ISwitchBindingExtension
    {
        object ValueIfFalse { get; set; }
        object ValueIfTrue { get; set; }
    }
}