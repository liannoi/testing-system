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

using System.Collections.Concurrent;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public class Bindable : INotifyPropertyChanged
    {
        private readonly ConcurrentDictionary<string, object> properties;

        protected Bindable()
        {
            properties = new ConcurrentDictionary<string, object>();
        }

        private bool CallPropertyChangeEvent { get; } = true;

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        protected T Get<T>(T defValue = default(T), [CallerMemberName] string name = null)
        {
            if (string.IsNullOrEmpty(name)) return defValue;
            if (properties.TryGetValue(name, out var value)) return (T) value;
            properties.AddOrUpdate(name, defValue, (s, o) => defValue);
            return defValue;
        }

        protected void Set(object value, [CallerMemberName] string name = null)
        {
            if (string.IsNullOrEmpty(name)) return;
            var isExists = properties.TryGetValue(name, out var getValue);
            if (isExists && Equals(value, getValue)) return;
            properties.AddOrUpdate(name, value, (s, o) => value);
            if (CallPropertyChangeEvent) OnPropertyChanged(name);
        }
    }
}