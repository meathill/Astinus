package brunch.clickHeatMap.map 
{
  import com.bit101.components.Accordion;
  import com.bit101.components.Label;
  import com.bit101.components.List;
  import com.bit101.components.Style;
  import com.bit101.components.VBox;
  import com.bit101.components.Window;
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import lib.component.data.dataBasicModel;
	
	/**
	 * 数据分析维度面板
	 * 总共5个面板，可以切换
	 * @author	Meathill
	 * @version	0.1(2011-03-22)
	 */
	public class dataPanel extends Accordion
	{
		public static var cw:int;
		public static var date:String;
		public static var search:String;
		public static var remote:String;
		
		public var pos:Array;
		
		private static const _DIMENSIONS:Vector.<String> = new < String > ['链接', '产品', '标题', '页面类型'];
		private static const _TYPE:Vector.<String> = new < String > ['url', 'product', 'title', 'page_type'];
		
		private var _url_list:List;
		private var _data:dataBasicModel;
		private var _cur:int = 0;
		
		public function dataPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
		}
		
		/************
		 * properties
		 * *********/
		public function set url(arr:Array):void {
			if (null == _url_list) {
				_url_list = new List(getWindowAt(0).content, 5, 5);
				_url_list.autoHideScrollBar = true;
				_url_list.setSize(_width - 10, _height - 90);
			}
			Style.fontSize = 10;
			_url_list.items = arr;
		}
		
		/************
		 * functions
		 * *********/
		override protected function init():void {
			super.init();
			
			_data = new dataBasicModel(remote);
			_data.addEventListener(Event.COMPLETE, dataLoadComplete);
			_data.addEventListener(IOErrorEvent.IO_ERROR, dataLoadFailed);
		}
		override protected function addChildren():void {
			Style.fontSize = 12;
			
			_vbox = new VBox(this);
			_vbox.spacing = 0;

			_windows = [];
			for (var i:int = 0, len:int = _DIMENSIONS.length; i < len; i += 1)	{
				var window:Window = new Window(_vbox, 0, 0, _DIMENSIONS[i]);
				window.grips.visible = false;
				window.draggable = false;
				window.addEventListener(Event.SELECT, onWindowSelect);
				if(i != 0) window.minimized = true;
				_windows.push(window);
			}
		}
		override protected function onWindowSelect(event:Event):void {
			var window:Window = event.target as Window;
			if (window.minimized) { 
				for each (var _win:Window in _windows){
					_win.minimized = true;
				}
				window.minimized = false;
			}
			_vbox.draw();
			
			_cur = _windows.indexOf(window);
			if (window.content.numChildren == 0) {
				_data.param = 'r=' + search +'&d=' + date + '&select=' + pos.join('.') + '.' + _TYPE[_cur] + '&w=' + cw;
				_data.load();
				new Label(window.content, 5, 5, '加载数据');
				enabled = false;
			}
		}
		private function dataLoadComplete(evt:Event):void {
			getWindowAt(_cur).content.removeChildAt(0);
			var _list:List = new List(getWindowAt(_cur).content, 5, 5, _data.srcData.split('\n'));
			_list.autoHideScrollBar = true;
			_list.setSize(_width - 10, _height - 90);
			enabled = true;
		}
		private function dataLoadFailed(evt:IOErrorEvent):void {
			trace('load failed..');
		}
		
		/************
		 * methods
		 * *********/
	}
}