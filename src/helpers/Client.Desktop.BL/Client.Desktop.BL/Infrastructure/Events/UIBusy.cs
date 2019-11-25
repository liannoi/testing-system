using System;

namespace Client.Desktop.BL.Infrastructure.Events
{
    public class UIBusyEventArgs : EventArgs
    {
        public string Action { get; set; }
    }

    public delegate void UIBusyEventHandler(object sender, UIBusyEventArgs e);
}
