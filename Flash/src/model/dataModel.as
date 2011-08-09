package src.model 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getTimer;
	import lib.component.data.dataBasicModel;
	
	/**
	 * 数据模型类
	 * 今天修改成支持帧循环加载
	 * @author	Meathill
	 * @version	0.2(2010-12-23)
	 */
	public class dataModel extends dataBasicModel
	{
		public static	const PATTERN:RegExp = /,+$/igm; // 末尾的连续逗号
		public static const	PAT2:RegExp = /.html\/+/igm; // 末尾的连续html
		public static const RATE:int = 240; // 每帧计算的条数
		public var tar:Sprite;
		
		private const _REMOTE:String = 'http://area.zol.com.cn/cgi-bin/path.cgi';
		private var _dict_obj:Object;
		private var _filter_arr:Array;
		private var _temp_arr:Array;
		private var _total:int = 0;
		private var _so:SharedObject;
		private var _max_col:int = 0;
		private var _is_filtered_bl:Boolean = false;
		
		public function dataModel() 
		{
			super(_REMOTE);
			
			init();
		}
		
		/***************
		 * properties
		 * ************/
		public function get data():Array {
			return _data_arr;
		}
		public function get maxCol():int {
			return _max_col;
		}
		public function get visited():Array {
			return _so.data.visited;
		}
		public function set isFiltered(bl:Boolean):void {
			_is_filtered_bl = bl;
		}
		public function get isFiltered():Boolean {
			return _is_filtered_bl;
		}
		
		/***************
		 * functions
		 * ************/
		private function init():void {
			soInit();
			
			_src.method = URLRequestMethod.POST;
			_param = new URLVariables();
		}
		private function soInit():void {
			_so = SharedObject.getLocal('zol_userroot');
			if (0 == _so.size) {
				//_so.data.unit = 1000;
				_so.data.visited = [];
				_so.flush();
			}
		}
		override protected function loadComplete(evt:Event):void {
			trace("data load complete..");
			trace(_loader.data);
			// 先放到一个临时数组中
			_loader.data = _loader.data.replace('<br>', '\n');
			_temp_arr = _loader.data.split('\n');
			_data_arr = [];
			_filter_arr = [];
			_dict_obj = { };
			_max_col = 0;
			_total = _temp_arr.length;
			trace('total : ', _total + " row(s)");
			if (_total > 1) {
				tar.addEventListener(Event.ENTER_FRAME, parseRootData);
			} else {
				loadFailed();
			}
		}
		private function parseRootData(evt:Event):void {
			var _time:int = getTimer();
			// 惯用帧频20，所以是50ms/帧，留一半的时间来干别的可以吧应该？
			while (getTimer() - _time < 25 && _temp_arr.length > 0) {
				// 每次循环240次，我比较喜欢这个数
				for (var i:int = 0, ilen:int = Math.min(RATE, _temp_arr.length); i < ilen; i += 1) { 
					var _str:String = _temp_arr.pop();
					_str = _str.replace(PATTERN, '');
					_str = _str.replace(PAT2, '.html');
					var _arr:Array = _str.split(',');
					if (_arr.length > 1) {
						// 整理数据字典，用来处理具体url
						var _num:int = int(_arr[_arr.length - 1]);
						for (var j:int = 0, len:int = _arr.length - 1; j < len; j += 1) { 
							var _uarr:Array = _arr[j].split('||');
							if (_dict_obj[_uarr[0]]) {
								if (_dict_obj[_uarr[0]][_uarr[1]]) {
									_dict_obj[_uarr[0]][_uarr[1]][j] += _num;
								} else {
									_dict_obj[_uarr[0]][_uarr[1]] = [];
									_dict_obj[_uarr[0]][_uarr[1]][j] = _num;
								}
							} else {
								_dict_obj[_uarr[0]] = { };
								_dict_obj[_uarr[0]][_uarr[1]] = [];
								_dict_obj[_uarr[0]][_uarr[1]][j] = _num;
							}
							_arr[j] = _uarr[0];
						}
						_data_arr.push(_arr);
						
						// 取最大列数
						_max_col = Math.max(_max_col, _arr.length);
					}/**/
				}
			}
			if (_temp_arr.length > 0) {
				var _evt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				_evt.bytesTotal = _total;
				_evt.bytesLoaded = _total - _temp_arr.length;
				dispatchEvent(_evt);
			} else {
				tar.removeEventListener(Event.ENTER_FRAME, parseRootData);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/****************
		 * methods
		 * *************/
		public function loadRemoteData(reg:String = '', date:String = '100220', level:String = '=5', nocache:String = ''):void { 
			_param.reg = reg;
			_param.date = date;
			_param.level = level;
			_param.nocache = nocache;
			_src.data = _param;
			_loader.load(_src);
			trace("get data from : " + _src.url + '?' + _src.data);
		}
		public function getNodeDataByName(nname:String):Object {
			return _dict_obj[nname];
		}
		public function filterData(url:String, index:int, isAll:Boolean = true):Array { 
			if (0 == _filter_arr.length || isAll) {
				_filter_arr = _data_arr.concat();
			}
			var _result:Array = [];
			for (var i:int = 0, len:int = _filter_arr.length; i < len; i += 1) {
				if (_filter_arr[i][index] == url) {
					_result.push(_filter_arr[i]);
				}
			}
			_filter_arr = _result;
			return _result;
		}
	}
}