package com.ryancanulla.apex.model
{
    import com.ryancanulla.apex.vo.ConfigVO;

    public class ConfigurationModel
    {

        private static var _instance:ConfigurationModel;
        private var _userSettings:ConfigVO;

        public function ConfigurationModel(enforcer:SingletonEnforcer) {
            init();
        }

        public static function getInstance():ConfigurationModel {
            if (ConfigurationModel._instance == null) {
                ConfigurationModel._instance = new ConfigurationModel(new SingletonEnforcer());
            }
            return ConfigurationModel._instance;
        }

        private function init():void {
            _userSettings = new ConfigVO;

            _userSettings.url = "http://admin.ryancanulla.com";
            _userSettings.port = "1234";
            _userSettings.username = "admin";
            _userSettings.password = "Summer855";
            _userSettings.refresh = 15;
        }

        public function get userSettings():ConfigVO {
            return _userSettings;
        }

        public function set userSettings(value:ConfigVO):void {
            _userSettings = value;
        }

    }
}

class SingletonEnforcer
{
}
