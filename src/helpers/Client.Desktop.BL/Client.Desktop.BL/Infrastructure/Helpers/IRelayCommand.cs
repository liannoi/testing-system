using System;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public interface IRelayCommand
    {
        event EventHandler CanExecuteChanged;

        bool CanExecute(object parameter);
        void Execute(object parameter);
    }
}