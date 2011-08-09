package src.model 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Meathill
	 */
	public class itemsMap implements IDataMap
	{
		private var _all_arr:Array = [];
		private var _line_arr:Array = [];
		
		public function itemsMap() 
		{
			
		}
		
		/**************
		 * functions
		 * ***********/
		
		/**************
		 * methods
		 * ***********/
		public function checkItemExist(item:String, x:uint):Boolean {
			var _is_check_bl:Boolean = true;
			if (x > _all_arr.length - 1) { 
				_is_check_bl = false;
			}
			if (_is_check_bl) {
				var _arr:Array = _all_arr[x];
				_is_check_bl = false;
				for (var i:uint = 0; i < _arr.length; i++) {
					if (_arr[i].caption == item) {
						_is_check_bl = true;
						break;
					}
				}
			}
			return _is_check_bl;
		}
		public function getYoffset(x:uint):uint {
			var _result:uint = 0;
			if (x <= _all_arr.length - 1) {
				_result = _all_arr[x].length;
			}
			return _result;
		}
		public function addItemAt(item:DisplayObject, x:uint, caption:String):void {
			
			if (x > _all_arr.length - 1) { 
				var _arr:Array = [];
				_all_arr[x] = _arr;
			}
			_all_arr[x].push( { caption:caption, item:item } );
		}
		public function getItemByIndex(caption:String, x:uint):DisplayObject {
			var _arr:Array = _all_arr[x];
			var _result:DisplayObject;
			for (var i:uint = 0; i < _arr.length; i++) {
				if (_arr[i].caption == caption) {
					_result = _arr[i].item;
					break;
				}
			}
			return _result;
		}
		public function checkLineExist(item1:DisplayObject, item2:DisplayObject):Boolean {
			var _is_check_bl:Boolean = false;
			for (var i:uint = 0; i < _line_arr.length; i++) {
				if (_line_arr[i].x == item1 && _line_arr[i].y == item2) {
					_is_check_bl = true;
					break;
				}
			}
			return _is_check_bl;
		}
		public function addLine(item1:DisplayObject, item2:DisplayObject, line:DisplayObject):void { 
			_line_arr.push( { x:item1, y:item2, line:line } );
		}
		public function getLineByPos(item1:DisplayObject, item2:DisplayObject):DisplayObject {
			var _line:DisplayObject;
			for (var i:uint = 0; i < _line_arr.length; i++) {
				if (_line_arr[i].x == item1 && _line_arr[i].y == item2) {
					_line = _line_arr[i].line;
					break;
				}
			}
			return _line;
		}
	}
}