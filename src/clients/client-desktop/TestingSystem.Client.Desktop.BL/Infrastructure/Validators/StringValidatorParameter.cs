﻿namespace TestingSystem.Client.Desktop.BL.Infrastructure.Validators
{
    public class StringValidatorParameter : IStringValidatorParameter
    {
        public int MaxLength { get; set; }
        public int MinLength { get; set; }
    }
}
