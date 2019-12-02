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

        public bool CallPropertyChangeEvent { get; } = true;

        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public T Get<T>(T defValue = default(T), [CallerMemberName] string name = null)
        {
            if (string.IsNullOrEmpty(name)) return defValue;

            if (properties.TryGetValue(name, out var value)) return (T) value;

            properties.AddOrUpdate(name, defValue, (s, o) => defValue);
            return defValue;
        }

        public void Set(object value, [CallerMemberName] string name = null)
        {
            if (string.IsNullOrEmpty(name)) return;

            var isExists = properties.TryGetValue(name, out var getValue);
            if (isExists && Equals(value, getValue)) return;

            properties.AddOrUpdate(name, value, (s, o) => value);

            if (CallPropertyChangeEvent) OnPropertyChanged(name);
        }
    }
}