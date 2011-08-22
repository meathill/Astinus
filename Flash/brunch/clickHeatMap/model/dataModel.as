package brunch.clickHeatMap.model 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.utils.getTimer;
	import lib.component.data.dataBasicModel;
	import lib.component.data.dataModelType;
	
	/**
	 * 数据模型类
	 * 比较复杂的运算现在都交给服务器来做
	 * @author	Meathill
	 * @version	0.1(2011-02-22)
	 */
	public class dataModel extends dataBasicModel
	{
		public static const URL:String = 'http://area.zol.com.cn/cgi-bin/click_url.cgi';
		public static const RATE:int = 1024; // 每帧计算的条数
		
		public var parent:DisplayObject;
		public var max:int = 0;
		public var total:int = 0;
		public var hits:int = 0;
		public var pageHeight:int = 0;
		public var offset:int = 0;
		public var count:int = 0;
		public var top:Vector.<Array>;
		
		public function dataModel() 
		{
			super(URL);
			_param = new URLVariables();
			_is_nocache_bl = true;
		}
		
		/************
		 * properties
		 * *********/
		public function set clientWidth(num:int):void {
			_param.w = num;
		}
		
		/************
		 * functions
		 * *********/
		/**
		 * 因为数据格式变化，所以覆盖这个函数
		 * @param	evt
		 */
		override protected function loadComplete(evt:Event):void {
			_data_arr = _loader.data.split('\n');
			total = _data_arr.length - 1;
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			// 开始分析数据
			_data_arr.pop(); // 最后一个总是空的
			top = new Vector.<Array>();
			parent.addEventListener(Event.ENTER_FRAME, parseData);
		}
		/**
		 * 分析数据，每帧执行一次，时间大概25ms，留出一半时间给渲染
		 * @param	evt
		 */
		private function parseData(evt:Event):void {
			var _time:int = getTimer();
			while (getTimer() - _time < 25 && _data_arr.length > 0) { 
				for (var i:int = 0, ilen:int = RATE < _data_arr.length ? RATE : _data_arr.length; i < ilen; i += 1) { 
					var _arr:Array = _data_arr.pop().split(',');
					for (var j:int = 0, jlen:int = _arr.length - 1; j < jlen; j += 1) {
						_arr[j] = int(_arr[j]);
					}
					top.push(_arr);
					if (_arr.length > 2) {
						hits += _arr[4];
						max = max > _arr[4] ? max : _arr[4];
						pageHeight = pageHeight > _arr[1] + _arr[3] ? pageHeight : _arr[1] + _arr[3];
					}
				}
			}
			if (_data_arr.length > 0) {
				var _evt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				_evt.bytesTotal = total;
				_evt.bytesLoaded = total - _data_arr.length;
				dispatchEvent(_evt);
			} else {
				parent.removeEventListener(Event.ENTER_FRAME, parseData);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function onEnterFrame(evt:Event):void {
			offset = ExternalInterface.call('ui.getScroll');
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/************
		 * methods
		 * *********/
		/**
		 * 从外部传值中取得参数，前面是测试用默认参数，取2011-02-17的经销商的数据
		 * @param	obj
		 */
		public function makeParam(obj:Object) {
			_param.r = 'http://dealer.zol.com.cn/';
			//_param.r = 'http://mobile.zol.com.cn/';
			_param.d = '110624';
			_param.nocache = 0;
			_param.visitor = 'new';
			for (var prop:String in obj) {
				trace(prop + ' : ' + obj[prop]);
				_param[prop] = obj[prop];
			}
		}
		public function getRectList(x:int = 0, y:int = 0, w:int = 0, h:int = 0, num:int = int.MAX_VALUE):Vector.<Array> {
			var _result:Vector.<Array> = new Vector.<Array>();
			for (var i:int = 0, len:int = top.length; i < len && _result.length < num; i += 1) {
				// 如果目标矩形和记录矩形相交
				var _left:Boolean = top[i][0] + top[i][2] < x, _right:Boolean = top[i][0] > x + w;
				var _top:Boolean = top[i][1] + top[i][3] < y, _btm:Boolean = top[i][1] > y + h;
				if (!(_left || _right || _top || _btm)) { 
					_result.push(top[i].concat());
				}
			}
			if (_result.length > 1) {
				for (i = 0; i < _result.length; i += 1) {
					for (var j:int = i + 1; j < _result.length; j += 1) {
						if (_result[i][5] == _result[j][5]) {
							_result[i][4] += _result[j][4];
							_result.splice(j, 1);
							j--;
						}
					}
				}
			}
			
			return _result;
		}
		public function startWatchScroll():void {
			parent.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}