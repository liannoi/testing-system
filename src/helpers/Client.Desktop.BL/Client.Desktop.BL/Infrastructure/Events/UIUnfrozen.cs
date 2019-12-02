using System;

namespace Client.Desktop.BL.Infrastructure.Events
{
    public class UiUnfrozenEventArgs : EventArgs
    {
        // ReSharper disable once UnusedMember.Global
        public string DefaultMessage { get; set; } = "Ready";

        // ReSharper disable once UnusedAutoPropertyAccessor.Global
        public string FailureMessage { get; set; }

        // ReSharper disable once UnusedAutoPropertyAccessor.Global
        public bool IsSuccess { get; set; }
    }

    public delegate void UiUnfrozenEventHandler(object sender, UiUnfrozenEventArgs e);
}