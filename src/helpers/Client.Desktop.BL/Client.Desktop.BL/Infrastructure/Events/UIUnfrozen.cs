using System;

namespace Client.Desktop.BL.Infrastructure.Events
{
    public class UIUnfrozenEventArgs : EventArgs
    {
        public string DefaultMessage { get; set; } = "Ready";

        public string FailureMessage { get; set; }

        public bool IsSuccess { get; set; }
    }

    public delegate void UIUnfrozenEventHandler(object sender, UIUnfrozenEventArgs e);
}
