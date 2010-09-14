package com.ryancanulla.apex.vo
{

    [Bindable]
    public class StatusVO
    {
        public var date:Date;
        public var temp:String;
        public var ph:String;
        public var amps:String;
        public var serial:String;
        public var powerFailed:Date;
        public var powerRestored:Date;
        public var mainLights:Boolean;
        public var mainActinic:Boolean;
        public var fans:Boolean;
        public var waves:Boolean;
        public var heater:Boolean;
    }
}

