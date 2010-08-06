package com.ryancanulla.apex.business {
	import com.asfusion.mate.core.GlobalDispatcher;
	import com.ryancanulla.apex.events.ApexEvent;
	import com.ryancanulla.apex.vo.SettingsVO;
	import com.ryancanulla.apex.vo.StatusVO;
	
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.Fault;
	
	public class StatusManager extends GlobalDispatcher {
		
//#################### VARS #################### 
	[Bindable] public var _status:StatusVO = new StatusVO();
	[Bindable] public var _datalog:ArrayCollection = new ArrayCollection();
	[Bindable] private var _settings:SettingsVO = new SettingsVO;
	private var _settingsSharedObject:SharedObject;
	private var _refreshTimer:Timer;
	
//#################### GETTERS/SETTERS #################### 	
	[Bindable(event="statusChange")]
	public function get status():StatusVO{
		return _status;
	}
	[Bindable(event="dataChange")]
	public function get dataLog():ArrayCollection{
		return _datalog;
	}
	[Bindable(event="settingsChange")]
	public function get settings():SettingsVO {
		return _settings;
	}
	
//#################### PUBLIC API #################### 		
		public function onGetStatus(e:XML):void{
			trace("onGetStatus");
			var probes:XMLList = new XMLList();
			probes = e.probes.probe;
			
			var outlets:XMLList = new XMLList();
			outlets = e.outlets.outlet;
			_status.serial = e..serial;
			//_status.date = new Date();
			//_status.date.setDate(e..date);
			trace(e..date);
			
			for(var i:uint=0;i<probes.length();i++){
			
				switch(probes[i]..name.toString()){
					case "Temp" :
					_status.temp = probes[i]..value.toString();
					//trace(_status.temp);
					break;
					
					case "pH" :
					_status.ph = probes[i]..value.toString();
					break;
					
					case "Amp_3" :
					_status.amps = probes[i]..value.toString();
					break;
				}
			}
			for(var j:uint=0;j<outlets.length();j++){
				switch(outlets[j]..name.toString()){
					case "Main10K" :
					_status.mainLights = outletState(outlets[j]..state.toString());
					break;
					case "Main20K" :
					_status.mainActinic = outletState(outlets[j]..state.toString());
					break;
					case "Fans" :
						_status.fans = outletState(outlets[j]..state.toString());
					break;
					case "Korilia4" :
						_status.waves = outletState(outlets[j]..state.toString());
					break;
					case "Heater" :
						_status.heater = outletState(outlets[j]..state.toString());
					break;
				}
			}
			CursorManager.removeBusyCursor();
			dispatchEvent (new Event("statusChange"));
		}
		public function onGetDatalog(e:XML):void{
			_datalog.removeAll();
			var _xmlObject:XMLList = new XMLList();
			_xmlObject = e..record;
			
			for(var i:uint=0;i<_xmlObject.length();i++){
				var _logStatus:StatusVO = new StatusVO();
				
				_logStatus.date = new Date(_xmlObject[i]..date.toString());
				
				//trace(_logStatus.date.toLocaleTimeString());
				//trace(_xmlObject.length());
				//_logStatus.date = new Date(_xmlObject[i]..date);;
				
				_logStatus.temp = _xmlObject[i].probe[0].value;
				_logStatus.ph = _xmlObject[i].probe[1].value;
				_logStatus.amps = _xmlObject[i].probe[2].value;
				_datalog.addItem(_logStatus);
			}	
			CursorManager.removeBusyCursor();
			dispatchEvent (new Event("dataChange"));
		}
		
		public function onFault(e:Fault):void{
			Alert.show("error", "error");
		}
		
		public function getSettings():void {
			
			_settingsSharedObject = SharedObject.getLocal("ReefDashboardSettings");
			
			_settings.url = _settingsSharedObject.data.url;
			_settings.port = _settingsSharedObject.data.port;
			_settings.username = _settingsSharedObject.data.username;
			_settings.password = _settingsSharedObject.data.password;
			_settings.refresh = _settingsSharedObject.data.refresh;
			
			//_settings.url = "http://admin.ryancanulla.com";
			//_settings.port = "1234";
			//_settings.username = "admin";
			//_settings.password = "Summer855";
			//_settings.refresh = .25;
			
			if(_refreshTimer && _settings.refresh) {
				trace("timer exitst")
				_refreshTimer.reset();
				_refreshTimer.delay = _settings.refresh * 60 * 1000, 10000;
				_refreshTimer.start();
					
			} else if(_settings.refresh) {
				trace("brand new timer");
				_refreshTimer = new Timer(_settings.refresh * 60 * 1000, 10000);
				_refreshTimer.addEventListener(TimerEvent.TIMER, refresh);
				_refreshTimer.start();
			} else {
				_refreshTimer = new Timer(.25 * 60 * 1000, 10000);
				_refreshTimer.addEventListener(TimerEvent.TIMER, refresh);
				_refreshTimer.start();
			}
			
			refresh();
		}
		
		public function updateSettings(e:SettingsVO):void {
			
			_settingsSharedObject.data.url = e.url;
			_settingsSharedObject.data.port = e.port;
			_settingsSharedObject.data.username = e.username;
			_settingsSharedObject.data.password = e.password;
			_settingsSharedObject.data.refresh = e.refresh;
			_settingsSharedObject.flush();
			
			var getSettings:ApexEvent = new ApexEvent(ApexEvent.GET_SETTINGS);
			dispatchEvent(getSettings);
			
			refresh();
			
		}
		
		private function refresh(e:TimerEvent = null):void {
			var getStatus:ApexEvent = new ApexEvent(ApexEvent.GET_STATUS);
			getStatus.settings = _settings;
			getStatus.statusURL = _settings.url + ":" + _settings.port + "/cgi-bin/status.xml";
			dispatchEvent(getStatus);
			
			var getDatalog:ApexEvent = new ApexEvent(ApexEvent.GET_DATALOG);
			getDatalog.settings = _settings;
			getDatalog.dataURL = _settings.url + ":" + _settings.port + "/cgi-bin/datalog.xml";
			dispatchEvent(getDatalog);
			
		}
		
		private function outletState(e:String):Boolean {
			switch(e){
				case "ON" :
					return true;
				break;
				case "AON" :
					return true;
				break;
				case "OFF" :
					return false;
				break;
				case "AOF" :
					return false;
				break;
			}
			return true;
		}
		
	}
}