package com.ryancanulla.apex.model.service
{
    import com.ryancanulla.apex.model.ConfigurationModel;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    import mx.collections.ArrayCollection;

    public class ApexService extends EventDispatcher
    {
        private static var _instance:ApexService;
        private var config:ConfigurationModel = ConfigurationModel.getInstance();
        private static const PROXY_SERVER:String = "http://ryancanulla.com/tank/phpProxy.php";
        private var _status:ArrayCollection;

        public function ApexService(enforcer:SingletonEnforcer) {
        }

        public static function getInstance():ApexService {
            if (ApexService._instance == null) {
                ApexService._instance = new ApexService(new SingletonEnforcer());
            }
            return ApexService._instance;
        }

        private function getTankStatus():void {
            var request:URLRequest = new URLRequest(PROXY_SERVER);
            var loader:URLLoader = new URLLoader();
            var vars:URLVariables = new URLVariables();

            vars.url = config.userSettings.url + ":" + config.userSettings.port + "/status.sht";
            vars.username = config.userSettings.username;
            vars.password = config.userSettings.password;

            request.method = URLRequestMethod.POST;
            request.data = vars;
            loader.addEventListener(Event.COMPLETE, handleTankStatusUpdate);
            //loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.load(request);
        }

        private function handleTankStatusUpdate(e:Event):void {
            _status = e as ArrayCollection;
            dispatchEvent(new Event("statusUpdated"));
        }

        private function changeTankStatus():void {
            var request:URLRequest = new URLRequest(PROXY_SERVER);
            var loader:URLLoader = new URLLoader();
            var vars:URLVariables = new URLVariables();

            vars.url = config.userSettings.url + ":" + config.userSettings.port + "/status.sht";
            vars.username = config.userSettings.username;
            vars.password = config.userSettings.password;

            vars.update = "_state=1&_state=1&_state=1&_state=1&_state=1&_state=1&_state=1&Main20K_state=2&Main10K_state=0&Korilia4_state=0&Korilia1_state=1&Heater_state=0&Fans_state=1&PowerTwo_state=2&EMPTY_state=2&SumpLight_state=0&Sump20K_state=1&CO2_state=0&CalcReactor_state=2&CalcMini_state=2&Skimmer_state=2&AutoTopOff_state=2&ReturnPump_state=2&Update=Update&FeedSel=0"
            request.method = URLRequestMethod.POST;
            request.data = vars;
            //loader.addEventListener(Event.COMPLETE, handleComplete);
            //loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.load(request);
        }

        public function get status():ArrayCollection {
            return _status;
        }

        public function set status(value:ArrayCollection):void {
            _status = value;
        }

    }
}

class SingletonEnforcer
{
}
