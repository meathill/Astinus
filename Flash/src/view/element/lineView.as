package src.view.element 
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import lib.component.tips.tipsBasicView;
	import src.event.adjustEvent;
	import src.view.ui.adjustWindowView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public final class lineView extends elementBasicView
	{
		public static var SPACE:int = 0;
		protected static var _LINE_MENU:ContextMenu;
		protected static var _adjust_window:adjustWindowView;
		protected static var _IS_ADJUSTABLE_BL:Boolean = false;
		
		private var _from:ballView;
		private var _to:ballView;
		private var _toY:int;
		private var _light_count:int = 0;
		
		public function lineView() 
		{
			init();
		}
		/*************
		 * properties
		 * **********/
		public function set from(mc:ballView):void {
			_from = mc;
		}
		public function get from():ballView {
			return _from;
		}
		public function set to(mc:ballView):void {
			_to = mc;
		}
		public function get to():ballView {
			return _to;
		}
		public function set lc(num:int):void {
			_light_count = num;
		}
		public function get lc():int {
			return _light_count;
		}
		
		/************
		 * functions
		 * *********/
		override protected function init():void {
			super.init();
			
			_bg_shape.alpha = .6;
			
			if (_IS_ADJUSTABLE_BL) {
				contextMenu = _LINE_MENU;
			}
		}
		override protected function removedHandler(evt:Event):void {
			super.removedHandler(evt);
			
			if (_IS_NUM_BL) {
				tipsBasicView.remove_target(this);
			}
		}
		
		/************
		 * methods
		 * *********/
		override public function mouseOnHandler(evt:MouseEvent = null, num:int = 0):void {
			super.mouseOnHandler(evt);
			
			_from.mouseOnHandler(null, 0);
			_to.mouseOnHandler(null, 0);
			_bg_shape.alpha = 1;
			
			// 如果非事件触发，显示百分比
			if (!evt) {
				_label_txt.text = uint(_count / num * 10000) / 100 + '%';
				addChild(_label_txt);
			}
		}
		override public function mouseOutHandler(evt:MouseEvent = null, num:int = 0):void {
			super.mouseOutHandler(evt);
			
			_from.mouseOutHandler(null, 0);
			_to.mouseOutHandler(null, 0);
			_bg_shape.alpha = .6;
			
			// 如果非事件触发，隐藏百分比
			if (!evt && _light_count == 0 && contains(_label_txt)) {
				removeChild(_label_txt);
			}
		}
		override public function draw():void {
			_bg_shape.graphics.clear();
			_bg_shape.graphics.lineStyle(1 + _count / _UNIT, 0x99CC00, 1);
			_bg_shape.graphics.lineTo(SPACE, _toY);
			
			_label_txt.x = (width - _label_txt.width) / 2;
			_label_txt.y = (height - _label_txt.height) / 2 + (_toY < 0?_toY:0);
			
			if (_IS_NUM_BL) {
				tipsBasicView.add_target(this, _count.toString());
			} else {
				mouseChildren = false;
				mouseEnabled = false;
			}
		}
		public function lineTo(y:int = 0):void { 
			_toY = y;
		}
		public function removeEnds():void {
			_from = null;
			_to = null;
		}		
		
		/********************
		 * static properties
		 * *****************/
		public static function set isAdjustable(bl:Boolean):void {
			_IS_ADJUSTABLE_BL = bl;
		}
		public static function get isAdjustable():Boolean {
			return _IS_ADJUSTABLE_BL;
		}
		
		/********************
		 * static functions
		 * *****************/
		private static function adjustWindowHandler(evt:ContextMenuEvent):void {
			if (!_adjust_window) {
				_adjust_window = new adjustWindowView();
				_adjust_window.addEventListener(adjustEvent.ADJUST, adjustHandler);
			}
			var _line:lineView = lineView(evt.mouseTarget);
			var _pos:Point = _line.localToGlobal(new Point(0, 0));
			_adjust_window.line = _line;
			_adjust_window.x = _pos.x;
			_adjust_window.y = _pos.y;
			_line.stage.addChild(_adjust_window);
		}
		private static function adjustHandler(evt:adjustEvent):void {
			var _line:lineView = evt.line;
			var _num:int = evt.num;
			_adjust_window.line = null;
			_adjust_window.stage.removeChild(_adjust_window);
			
			// 开始处理加减鸟
			_line.num += _num;
			_line.draw();
			_line.from.num += _num;
			_line.from.draw();
			_line.to.num += _num;
			_line.to.draw();
		}
		
		/********************
		 * static methods
		 * *****************/
		public static function lineMenuInit():void {
			_LINE_MENU = new ContextMenu();
			_LINE_MENU.hideBuiltInItems();
			
			var _num_adjust_item:ContextMenuItem = new ContextMenuItem('调整数字');
			_num_adjust_item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, adjustWindowHandler);
			_LINE_MENU.customItems.push(_num_adjust_item);
		}
	}
}