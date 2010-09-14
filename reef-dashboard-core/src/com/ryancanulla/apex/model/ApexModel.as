package com.ryancanulla.apex.model
{
    import com.ryancanulla.apex.model.service.ApexService;

    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import mx.collections.ArrayCollection;

    public class ApexModel extends EventDispatcher
    {

        private static var _instance:ApexModel;
        private var _status:ArrayCollection;
        private var _logs:ArrayCollection;

        private var service:ApexService = ApexService.getInstance();

        public function ApexModel(enforcer:SingletonEnforcer) {
            service.addEventListener("statusUpdated", setStatusData);
        }

        public static function getInstance():ApexModel {
            if (ApexModel._instance == null) {
                ApexModel._instance = new ApexModel(new SingletonEnforcer());
            }
            return ApexModel._instance;
        }

        private function setStatusData():void {
            _status = service.status;
        }

        public function get status():ArrayCollection {
            return _status;
        }

        public function get logs():ArrayCollection {
            return _logs;
        }

    }
}

class SingletonEnforcer
{
}
