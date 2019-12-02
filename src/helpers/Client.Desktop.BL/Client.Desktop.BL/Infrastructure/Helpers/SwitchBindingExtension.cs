using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;
using System.Windows.Markup;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public class SwitchBindingExtension : Binding
    {
        public SwitchBindingExtension(string path, object valueIfTrue, object valueIfFalse) : base(path)
        {
            Initialize();
            ValueIfTrue = valueIfTrue;
            ValueIfFalse = valueIfFalse;
        }

        // ReSharper disable once MemberCanBePrivate.Global
        [ConstructorArgument("valueIfTrue")] public object ValueIfTrue { get; set; }

        // ReSharper disable once MemberCanBePrivate.Global
        [ConstructorArgument("valueIfFalse")] public object ValueIfFalse { get; set; }

        private void Initialize()
        {
            ValueIfTrue = DoNothing;
            ValueIfFalse = DoNothing;
            Converter = new SwitchConverter(this);
        }

        private class SwitchConverter : IValueConverter
        {
            private readonly SwitchBindingExtension switchExtension;

            public SwitchConverter(SwitchBindingExtension switchExtension)
            {
                this.switchExtension = switchExtension;
            }

            #region IValueConverter Members

            public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
            {
                try
                {
                    var b = System.Convert.ToBoolean(value);
                    return b ? switchExtension.ValueIfTrue : switchExtension.ValueIfFalse;
                }
                catch
                {
                    return DependencyProperty.UnsetValue;
                }
            }

            public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
            {
                return DoNothing;
            }

            #endregion
        }
    }
}