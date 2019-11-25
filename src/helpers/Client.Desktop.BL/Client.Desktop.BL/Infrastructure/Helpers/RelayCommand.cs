using System;
using System.Windows.Input;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public class RelayCommand : ICommand, IRelayCommand
    {
        private readonly Action<object> action;
        private readonly Func<object, bool> func;

        public RelayCommand(Action<object> action)
        {
            this.action = action;
        }

        public RelayCommand(Action<object> action, Func<object, bool> func)
        {
            this.action = action;
            this.func = func;
        }

        public bool CanExecute(object parameter)
        {
            return func == null || func(parameter);
        }

        public void Execute(object parameter)
        {
            action(parameter);
        }

        public event EventHandler CanExecuteChanged
        {
            add
            {
                CommandManager.RequerySuggested += value;
            }

            remove
            {
                CommandManager.RequerySuggested -= value;
            }
        }
    }
}
