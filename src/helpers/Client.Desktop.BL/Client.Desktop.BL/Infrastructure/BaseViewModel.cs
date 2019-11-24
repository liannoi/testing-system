using Client.Desktop.BL.Infrastructure.Helpers;
using System;
using System.Collections.Concurrent;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Client.Desktop.BL.Infrastructure
{
    public class BaseViewModel : Bindable, IDisposable
    {
        private readonly CancellationTokenSource cancellationTokenSource;
        private readonly ConcurrentDictionary<string, ICommand> cachedCommands;

        public bool IsLoadDataStarted
        {
            get => Get<bool>();
            protected internal set => Set(value);
        }

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

        public void LoadData()
        {
            if (IsLoadDataStarted)
            {
                return;
            }

            IsLoadDataStarted = true;
            Task.Run(LoadDataAsync, CancellationToken);
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

        /// <summary>
        /// Override this method for load data.
        /// </summary>
        protected virtual Task LoadDataAsync()
        {
            return Task.FromResult(0);
        }

        protected virtual void Dispose(bool disposing)
        {
            CancelRequests();
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
