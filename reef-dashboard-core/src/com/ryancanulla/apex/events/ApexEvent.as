package com.ryancanulla.apex.events
{
    import com.ryancanulla.apex.vo.ConfigVO;

    import flash.events.Event;

    public class ApexEvent extends Event
    {

        public static const STATUS_UPDATED:String = "ApexEvent_GET_STATUS";
        public static const GET_DATALOG:String = "ApexEvent_GET_DATALOG";
        public static const GET_SETTINGS:String = "ApexEvent_GET_SETTINGS";
        public static const UPDATE_SETTINGS:String = "ApexEvent_UPDATE_SETTINGS";
        public static const DELETE_SETTINGS:String = "ApexEvent_DELETE_SETTINGS";

        public var settings:ConfigVO;
        public var statusURL:String;
        public var dataURL:String;

//		public function get settings():SettingsVO {
//
//			return _settings;
//
//		}
//		public function set settings(e:SettingsVO):void {
//
//			_settings = e;
//
//		}

        public function ApexEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }

    }
}
