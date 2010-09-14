package com.ryancanulla.apex.air.controller
{
    import com.ryancanulla.apex.air.views.MainAirContainer;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class ApexAirController
    {
        private var _view:MainAirContainer;

        public function ApexAirController(e:DisplayObject) {
            _view = e as MainAirContainer;
            setViewListeners();
        }

        private function setViewListeners():void {
            _view.controllerWrap.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
        }

        private function moveWindow(e:MouseEvent):void {
            _view.stage.nativeWindow.startMove();
        }

    }
}
