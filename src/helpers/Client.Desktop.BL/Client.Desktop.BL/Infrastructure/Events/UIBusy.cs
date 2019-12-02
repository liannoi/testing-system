using System;

namespace Client.Desktop.BL.Infrastructure.Events
{
    public class UiBusyEventArgs : EventArgs
    {
        // ReSharper disable once UnusedAutoPropertyAccessor.Global
        public string Action { get; set; }
    }

    public delegate void UiBusyEventHandler(object sender, UiBusyEventArgs e);
}