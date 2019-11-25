using System.ComponentModel;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public interface IBindable
    {
        event PropertyChangedEventHandler PropertyChanged;
    }
}