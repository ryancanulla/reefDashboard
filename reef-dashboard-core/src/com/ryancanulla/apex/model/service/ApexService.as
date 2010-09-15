package com.ryancanulla.apex.model.service
{
    import com.ryancanulla.apex.events.ApexEvent;
    import com.ryancanulla.apex.model.ConfigurationModel;
    import com.ryancanulla.apex.vo.CurrentStatusVO;

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
        private var _currentStatus:CurrentStatusVO;

        public function ApexService(enforcer:SingletonEnforcer) {
            _currentStatus = new CurrentStatusVO();
            getTankStatus();
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

            vars.url = config.userSettings.url + ":" + config.userSettings.port + "/cgi-bin/status.xml";
            vars.username = config.userSettings.username;
            vars.password = config.userSettings.password;

            request.method = URLRequestMethod.POST;
            request.data = vars;
            loader.addEventListener(Event.COMPLETE, handleTankStatusUpdate);
            //loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.load(request);
        }

        private function handleTankStatusUpdate(e:Event):void {
            var xml:XML = new XML(e.currentTarget.data);
            var probes:XMLList = new XMLList(xml..probe);
            var outlets:XMLList = new XMLList(xml..outlet);

            for (var i:uint = 0; i < probes.length(); i++) {
                if (probes[i].name == "Temp") {
                    _currentStatus.temp = probes[i].value;
                }
                else if (probes[i].name == "pH") {
                    _currentStatus.ph = probes[i].value;
                }
                else if (probes[i].name == "Amp_3") {
                    _currentStatus.amps = probes[i].value;
                }
            }

            for (var j:uint = 0; j < outlets.length(); j++) {
                if (outlets[j].name == "Main10K") {
                    _currentStatus.mainLights = outletState(outlets[j].state);
                }
                else if (outlets[j].name == "Main20K") {
                    _currentStatus.mainActinic = outletState(outlets[j].state);
                }
                else if (outlets[j].name == "Fans") {
                    _currentStatus.fans = outletState(outlets[j].state);
                }
                else if (outlets[j].name == "Korilia4") {
                    _currentStatus.waves = outletState(outlets[j].state);
                }
                else if (outlets[j].name == "Heater") {
                    _currentStatus.heater = outletState(outlets[j].state);
                }
            }
            dispatchEvent(new ApexEvent(ApexEvent.STATUS_UPDATED));
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

        private function outletState(e:String):Boolean {
            switch (e) {
                case "ON":
                    return true;
                    break;
                case "AON":
                    return true;
                    break;
                case "OFF":
                    return false;
                    break;
                case "AOF":
                    return false;
                    break;
            }
            return true;
        }

        public function get status():ArrayCollection {
            return _status;
        }

        public function set status(value:ArrayCollection):void {
            _status = value;
        }

        public function get currentStatus():CurrentStatusVO {
            return _currentStatus;
        }
    }
}

class SingletonEnforcer
{
}
