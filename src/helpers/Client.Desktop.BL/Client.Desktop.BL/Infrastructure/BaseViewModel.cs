// Copyright 2019 Maksym Liannoi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using System;
using System.Collections.Concurrent;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Windows;
using System.Windows.Input;
using Client.Desktop.BL.Infrastructure.Events;
using Client.Desktop.BL.Infrastructure.Helpers;

namespace Client.Desktop.BL.Infrastructure
{
    public class BaseViewModel : Bindable, IDisposable, INotifyUiBusy, INotifyUiUnfrozen
    {
        private readonly ConcurrentDictionary<string, ICommand> cachedCommands;
        private readonly CancellationTokenSource cancellationTokenSource;

        public BaseViewModel()
        {
            cancellationTokenSource = new CancellationTokenSource();
            cachedCommands = new ConcurrentDictionary<string, ICommand>();
        }

        public CancellationToken CancellationToken => cancellationTokenSource?.Token ?? CancellationToken.None;

        public void Dispose()
        {
            Dispose(true);
            cancellationTokenSource.Dispose();
            GC.SuppressFinalize(this);
        }

        public event UiBusyEventHandler UiBusy;
        public event UiUnfrozenEventHandler UiUnfrozen;

        ~BaseViewModel()
        {
            Dispose(false);
        }

        public void CancelRequests()
        {
            cancellationTokenSource.Cancel();
        }

        protected ICommand MakeCommand(Action<object> commandAction, [CallerMemberName] string propertyName = null)
        {
            return GetCommand(propertyName) ?? SaveCommand(new RelayCommand(commandAction), propertyName);
        }

        protected ICommand MakeCommand(Action<object> commandAction, Func<object, bool> func,
            [CallerMemberName] string propertyName = null)
        {
            return GetCommand(propertyName) ?? SaveCommand(new RelayCommand(commandAction, func), propertyName);
        }

        protected virtual void Dispose(bool disposing)
        {
            CancelRequests();
        }

        protected virtual void OnUiBusy(UiBusyEventArgs e)
        {
            UiBusy?.Invoke(this, e);
        }

        protected virtual void OnUiUnfrozen(UiUnfrozenEventArgs e)
        {
            UiUnfrozen?.Invoke(this, e);
        }

        protected void NotifyOnUiBusy(string action)
        {
            OnUiBusy(new UiBusyEventArgs
            {
                Action = action
            });
        }

        protected void NotifyOnUiUnfrozen()
        {
            OnUiUnfrozen(new UiUnfrozenEventArgs
            {
                IsSuccess = true
            });
        }

        protected void NotifyOnUiUnfrozen(Exception e)
        {
            OnUiUnfrozen(new UiUnfrozenEventArgs
            {
                FailureMessage = e.Message,
                IsSuccess = false
            });
        }

        protected void DefaultProcessException(Exception e)
        {
            MessageBox.Show(e.Message);
            NotifyOnUiUnfrozen(e);
        }

        // TODO: Describe non-statistical methods that would show download windows, hiding them. Also, you need to describe static methods for displaying messages for the client ("Are you sure ...?").

        private ICommand SaveCommand(ICommand command, string propertyName)
        {
            if (string.IsNullOrEmpty(propertyName)) throw new ArgumentNullException(nameof(propertyName));
            if (!cachedCommands.ContainsKey(propertyName)) cachedCommands.TryAdd(propertyName, command);
            return command;
        }

        private ICommand GetCommand(string propertyName)
        {
            if (string.IsNullOrEmpty(propertyName)) throw new ArgumentNullException(nameof(propertyName));
            return cachedCommands.TryGetValue(propertyName, out var cachedCommand) ? cachedCommand : null;
        }
    }
}