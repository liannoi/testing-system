using System;
using System.Globalization;
using System.Windows.Data;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Client.Desktop.BL.Converters
{
    public class RemainQuestionsConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (!(values[0] is RemainQuestionsBusinessObject))
            {
                return string.Empty;
            }

            RemainQuestionsBusinessObject result = values[0] as RemainQuestionsBusinessObject;
            return $"{result.Current} / {result.All}";
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotSupportedException();
        }
    }
}
