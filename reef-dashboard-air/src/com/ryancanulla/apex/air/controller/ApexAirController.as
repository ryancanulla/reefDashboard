package com.ryancanulla.apex.air.controller
{
    import com.ryancanulla.apex.air.views.MainAirContainer;
    import com.ryancanulla.apex.events.ApexEvent;
    import com.ryancanulla.apex.model.ApexModel;
    import com.ryancanulla.apex.model.service.ApexService;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ApexAirController
    {
        private var view:MainAirContainer;
        private var model:ApexModel;
        private var service:ApexService;

        public function ApexAirController(e:DisplayObject) {
            view = e as MainAirContainer;
            model = ApexModel.getInstance();
            service = ApexService.getInstance();

            setViewListeners();
            setServiceListeners();
            updateViewProperties();
        }

        private function setViewListeners():void {
            view.controllerWrap.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
            view.closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
            view.minimizeButton.addEventListener(MouseEvent.CLICK, minimizeWindow);
            view.configButton.addEventListener(MouseEvent.CLICK, toggleSettings);
            view.chartingButton.addEventListener(MouseEvent.CLICK, toggleChart);
        }

        private function setServiceListeners():void {
            service.addEventListener(ApexEvent.STATUS_UPDATED, updateViewProperties);
        }

        private function updateViewProperties(e:Event = null):void {
            view.footerCopy.textDisplay.text = "ryancanulla.com";

            view.temperature.textDisplay.text = model.currentStatus.temp;
            view.ph.textDisplay.text = "PH: " + model.currentStatus.ph;
            view.amps.textDisplay.text = model.currentStatus.amps + " AMPS";

            view.mainDaylight.selected = model.currentStatus.mainLights;
            view.mainActinic.selected = model.currentStatus.mainActinic;
            view.mainFans.selected = model.currentStatus.fans;
            view.mainWave.selected = model.currentStatus.waves;
            view.mainHeater.selected = model.currentStatus.heater;
        }

        private function toggleChart(e:MouseEvent):void {
            if (view.currentState == "expanded") {
                view.currentState = "compact";
            }
            else if (view.currentState != "expanded") {
                view.currentState = "expanded";
            }
        }

        private function toggleSettings(e:MouseEvent):void {

            if (view.currentState == "settings") {
                view.currentState = "compact";
            }
            else if (view.currentState != "settings") {
                view.currentState = "settings";
            }
        }

        private function moveWindow(e:MouseEvent):void {
            view.stage.nativeWindow.startMove();
        }

        private function minimizeWindow(evt:MouseEvent):void {
            view.stage.nativeWindow.minimize();
        }

        private function closeWindow(evt:MouseEvent):void {
            view.stage.nativeWindow.close();
        }

    }
}
