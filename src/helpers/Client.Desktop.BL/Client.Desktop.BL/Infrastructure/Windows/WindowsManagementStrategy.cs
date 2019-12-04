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

using System.Windows;

namespace Client.Desktop.BL.Infrastructure.Windows
{
    public class WindowsManagementStrategy<TViewModel, TWindow> : IWindowsManagementStrategy where TViewModel : BaseViewModel
        where TWindow : Window
    {
        private readonly TViewModel viewModel;
        private readonly TWindow window;

        public WindowsManagementStrategy(TViewModel viewModel, TWindow window)
        {
            this.viewModel = viewModel;
            this.window = window;
        }

        public Application Current => Application.Current;

        public WindowCollection Windows => Application.Current.Windows;

        public void Open()
        {
            DataContext();
            window.Show();
        }

        public void OpenDialog()
        {
            DataContext();
            window.ShowDialog();
        }

        public void CloseParent()
        {
            Current.MainWindow?.Close();
        }

        public void CloseLatest()
        {
            CloseParent();
            Windows[Windows.Count - 1].Close();
        }

        private void DataContext()
        {
            window.DataContext = viewModel;
        }
    }
}