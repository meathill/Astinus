package src.view.ui 
{
	import com.bit101.components.List;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * 显示节点详细数据
	 * @author Meathill
	 */
	public class nodeDetailWindow extends commonWindowView
	{
		private static const _SPACE:int = 15;
		private static const _COLOR:uint = 0xff6600;
		
		private var _data:Vector.<Object>;
		private var _url_list:List;
		private var _max_width:int = 0;
		private var _toX:int = 0;
		private var _toY:int = 0;
		private var _index:int = 0;
		private var _total:int = 1;
		private var _is_num_bl:Boolean = false;
		
		public function nodeDetailWindow() 
		{
			super();
			
			_url_list = new List(this, 0, 19);
			_url_list.autoHideScrollBar = true;
			_url_list.setSize(200, 200);
			_url_list.addEventListener(Event.SELECT, gotoURL);
		}
		
		/**************
		 * properties
		 * ***********/
		public function set isNum(bl:Boolean):void {
			_is_num_bl = bl;
		}
		public function set url(str:String):void {
			_title_txt.text = str;
			name = str + '#' + _index;
		}
		public function set index(num:int):void {
			_index = num;
			name = _title_txt.text + '#' + _index;
		}
		public function set total(num:int):void {
			_total = num;
		}
		
		/***************
		 * functions
		 * ************/
		override protected function startMove(evt:MouseEvent = null):void {
			super.startMove(evt);
			addEventListener(Event.ENTER_FRAME, lineToOrigin);
		}
		override protected function stopMove(evt:MouseEvent = null):void {
			super.stopMove(evt);
			removeEventListener(Event.ENTER_FRAME, lineToOrigin);
		}
		private function lineToOrigin(evt:Event):void {
			graphics.clear();
			graphics.lineStyle(0, _COLOR);
			graphics.lineTo(_toX - x, _toY - y);
		}
		override protected function addedHandler(evt:Event):void {
			_toX = x;
			_toY = y;
			
			super.addedHandler(evt);
		}
		override protected function closeHandler(evt:MouseEvent = null):void {
			graphics.clear();
			
			super.closeHandler(evt);
		}
		private function gotoURL(evt:Event):void {
			navigateToURL(new URLRequest(_url_list.selectedItem.toString()), '_blank');
		}
		
		/***************
		 * methods
		 * ************/
		public function showTable(data:Object):void {
			_data = new Vector.<Object>;
			for (var prop:String in data) {
				if (data[prop][_index]) {
					_data.push( { url:prop, num:data[prop][_index] } );
				}
			}
			_data.sort(function(obj1:Object, obj2:Object) { return obj1.num - obj2.num; } );
			
			_url_list.removeAll();
			for (var i:int = 0, len:int = _data.length < 60 ? _data.length : 60; i < len; i += 1) { 
				_max_width = Math.max(_data[i].url.length, _max_width);
				if (_is_num_bl) {
					_url_list.addItem('[' + _data[i].num + ']' + _data[i].url);
				} else {
					_url_list.addItem('[' + Math.round(_data[i].num / _total * 1000) / 10 + '%]' + _data[i].url);
				}
			}
			_url_list.setSize(Math.max(200, Math.min(300, _max_width * 8)), Math.max(1, Math.min(10, _data.length)) * 20);
				
			// 画背景
			_title_bar.width = _url_list.width + 10;
			_title_bar.height = _url_list.height + 30;
		}
	}
}