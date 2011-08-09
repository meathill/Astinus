package src.view 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import src.view.element.elementBasicView;
	import src.view.element.ballView;
	import src.view.element.lineView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class columnView extends Sprite
	{
		public static const SPACE:int = 40;
		public static const MIN_WIDTH:int = 100;
		public static var WIDTH:Number = 0;
		public static var MAX_ITEM:int = 0;
		
		protected static var _ITEMS_ARR:Vector.<columnView>;
		protected static var _FILTER_ARR:Vector.<String>;
		protected static var _USERIN:int;
		protected static var _BOTTOM_LMT:int = 0;
		protected static var _IS_NUM_BL:Boolean = true;
		
		private var _label_txt:TextField;
		private var _only_ball:ballView;
		private var _root_num:int = 0;
		
		public function columnView() 
		{
			init();
		}
		
		/**************
		 * properties
		 * ***********/
		public function set label(str:String):void {
			_label_txt.text = str;
		}
		public function get label():String {
			return _label_txt.text;
		}
		public function get total():int {
			return _root_num;
		}
		
		/*************
		 * functions
		 * **********/
		private function init():void {
			getChildAt(0).width = WIDTH;
			
			_label_txt = TextField(getChildAt(1));
			_label_txt.mouseEnabled = false;
			_label_txt.width = WIDTH;
			
			_ITEMS_ARR.push(this);
		}
		private function showLabel():void {
			if (elementBasicView.isNum) {
				_label_txt.text = _root_num.toString();
			} else {
				_label_txt.text = '';
			}
			if (_USERIN) {
				_label_txt.appendText("(" + Number(int(_root_num / _USERIN * 10000) * .01).toString().substr(0, 5) + "%)");
			}
		}
		
		/*************
		 * methods
		 * **********/
		override public function addChild(child:DisplayObject):DisplayObject {
			ballView(child).addEventListener(MouseEvent.CLICK, clickHandler);
			
			return super.addChild(child);
		}
		override public function removeChild(child:DisplayObject):DisplayObject {
			ballView(child).removeEventListener(MouseEvent.CLICK, clickHandler);
			
			return super.removeChild(child);
		}
		public function clickHandler(evt:MouseEvent = null):void {
			if (_only_ball != null) {
				_only_ball.status = false;
				_only_ball.lightAllLine(false, evt);
				_only_ball = null;
				for (var i:int = 2, len:int = numChildren; i < len; i += 1) {
					if (ballView(getChildAt(i)).num > _BOTTOM_LMT) {
						ballView(getChildAt(i)).show();
					}
				}
			} else if (evt != null) { 
				_only_ball = ballView(evt.currentTarget);
				_only_ball.status = true;
				_only_ball.lightAllLine(true);
				for (var i:int = 2, len:int = numChildren; i < len; i += 1) {
					var _ball:ballView = ballView(getChildAt(i));
					if (_only_ball != _ball) {
						_ball.hide();
					}
				}
			}
			showLabel();
		}
		public function count():int {
			for (var i:int = 2, len:int = numChildren; i < len; i += 1) {
				if (!ballView(getChildAt(i)).exit) {
					_root_num += ballView(getChildAt(i)).num;
				}
			}
			if (!elementBasicView.isNum) {
				for (i = 2; i < len; i += 1) {
					ballView(getChildAt(i)).showLable();
				}
			}
			showLabel();
			return _root_num;
		}
		public function filterNode():void {
			for (var i:int = 2, len:int = numChildren; i < len; i += 1) {
				if (ballView(getChildAt(i)).num < _BOTTOM_LMT || -1 != _FILTER_ARR.indexOf(getChildAt(i).name)) {
					ballView(getChildAt(i)).hide();
				} else {
					ballView(getChildAt(i)).show();
				}
			}
		}
		public function dragBg():void {
			graphics.beginFill(0xffffff, .2);
			graphics.drawRect(0, 0, WIDTH, MAX_ITEM * SPACE);
			graphics.endFill();
		}
		
		/******************
		 * static properties
		 * ***************/
		public static function set isNum(bl:Boolean):void {
			_IS_NUM_BL = bl;
		}
		public static function get isNum():Boolean {
			return _IS_NUM_BL;
		}
		
		/******************
		 * static methods
		 * ***************/
		public static function init():void {
			_ITEMS_ARR = new Vector.<columnView>;
			_FILTER_ARR = new Vector.<String>;
			_USERIN = 0;
			MAX_ITEM = 0;
		}
		public static function itemsInit():void {
			var _is_start_bl:Boolean = true;
			for each (var _item:columnView in _ITEMS_ARR) {
				MAX_ITEM = _item.numChildren > MAX_ITEM ? _item.numChildren:MAX_ITEM;
				if (_is_start_bl) {
					_is_start_bl = false;
					_USERIN = _item.count();
				} else {
					_item.count();
				}
			}
			// 处理来源列
			_item = columnView(_ITEMS_ARR[0]);
			_item.label = '来源';
			_item.dragBg();
		}
		public static function filterNodeLess(num:int):void {
			_BOTTOM_LMT = num;
			for each (var _item:columnView in _ITEMS_ARR) {
				_item.filterNode();
			}
		}
		public static function filterNodeByName(node:String, bl:Boolean):void {
			// 先根据bl判断是隐藏还是显示
			if (bl && -1 != _FILTER_ARR.indexOf(node)) {
				_FILTER_ARR.splice(_FILTER_ARR.indexOf(node), 1);
			} else if ( -1 == _FILTER_ARR.indexOf(node)) { 
				_FILTER_ARR.push(node);
			}
			for each (var _item:columnView in _ITEMS_ARR) {
				_item.filterNode();
			}
		}
	}
}