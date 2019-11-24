using Client.Desktop.BL.Infrastructure.Events;
using Client.Desktop.BL.Infrastructure.Events.Interfaces;
using Client.Desktop.BL.Infrastructure.Helpers;
using System;
using System.Collections.Concurrent;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Client.Desktop.BL.Infrastructure
{
    public class BaseViewModel : Bindable, IDisposable, INotifyUIBusy, INotifyUIUnfrozen
    {
        private readonly CancellationTokenSource cancellationTokenSource;
        private readonly ConcurrentDictionary<string, ICommand> cachedCommands;

        public event UIBusyEventHandler UIBusy;
        public event UIUnfrozenEventHandler UIUnfrozen;

        public CancellationToken CancellationToken => cancellationTokenSource?.Token ?? CancellationToken.None;

        public BaseViewModel()
        {
            cancellationTokenSource = new CancellationTokenSource();
            cachedCommands = new ConcurrentDictionary<string, ICommand>();
        }

        ~BaseViewModel()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public void CancelRequests()
        {
            cancellationTokenSource.Cancel();
        }

        protected ICommand MakeCommand(Action<object> commandAction, [CallerMemberName] string propertyName = null)
        {
            return GetCommand(propertyName) ?? SaveCommand(new RelayCommand(commandAction), propertyName);
        }

        protected ICommand MakeCommand(Action<object> commandAction, Func<object, bool> func, [CallerMemberName] string propertyName = null)
        {
            return GetCommand(propertyName) ?? SaveCommand(new RelayCommand(commandAction, func), propertyName);
        }

        protected virtual void Dispose(bool disposing)
        {
            CancelRequests();
        }

        protected virtual void OnUIBusy(UIBusyEventArgs e)
        {
            UIBusy?.Invoke(this, e);
        }

        protected virtual void OnUIUnfrozen(UIUnfrozenEventArgs e)
        {
            UIUnfrozen?.Invoke(this, e);
        }

        // TODO: Describe non-statistical methods that would show download windows, hiding them. Also, you need to describe static methods for displaying messages for the client ("Are you sure ...?").

        private ICommand SaveCommand(ICommand command, string propertyName)
        {
            if (string.IsNullOrEmpty(propertyName))
            {
                throw new ArgumentNullException(nameof(propertyName));
            }

            if (!cachedCommands.ContainsKey(propertyName))
            {
                cachedCommands.TryAdd(propertyName, command);
            }

            return command;
        }

        private ICommand GetCommand(string propertyName)
        {
            if (string.IsNullOrEmpty(propertyName))
            {
                throw new ArgumentNullException(nameof(propertyName));
            }

            return cachedCommands.TryGetValue(propertyName, out ICommand cachedCommand) ? cachedCommand : null;
        }
    }
}
