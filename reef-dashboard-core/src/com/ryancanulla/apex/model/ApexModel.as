package com.ryancanulla.apex.model
{
    import com.ryancanulla.apex.events.ApexEvent;
    import com.ryancanulla.apex.model.service.ApexService;
    import com.ryancanulla.apex.vo.CurrentStatusVO;

    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import mx.collections.ArrayCollection;

    public class ApexModel extends EventDispatcher
    {

        private static var _instance:ApexModel;
        private var _status:ArrayCollection;
        private var _logs:ArrayCollection;
        private var _currentStatus:CurrentStatusVO;

        private var service:ApexService;

        public function ApexModel(enforcer:SingletonEnforcer) {
            service = ApexService.getInstance();

            init();

        }

        private function init():void {
            _currentStatus = new CurrentStatusVO;
        }

        public static function getInstance():ApexModel {
            if (ApexModel._instance == null) {
                ApexModel._instance = new ApexModel(new SingletonEnforcer());
            }
            return ApexModel._instance;
        }

        public function get logs():ArrayCollection {
            return _logs;
        }

        public function get currentStatus():CurrentStatusVO {
            return service.currentStatus;
        }

    }
}

class SingletonEnforcer
{
}
