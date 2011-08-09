package src.view.element 
{
	import com.greensock.TweenLite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import src.view.columnView;
	import src.view.mapView;
	import src.event.mapEvent;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public final class ballView extends elementBasicView
	{	
		public static var MAP:mapView;
		
		protected static var _NODE_MENU:ContextMenu;
		private static var _filterItem:ContextMenuItem;
		private static var _filterAgainItem:ContextMenuItem;
		
		private var _connect:Vector.<lineView>;
		private var _is_exit_bl:Boolean = false;
		private var _filter:GlowFilter;
		private var _color:uint = 0xcccccc;
		
		public function ballView() 
		{
			init();
		}
		
		/*************
		 * properties
		 * **********/
		public function get connected():Vector.<lineView> {
			return _connect;
		}
		public function set exit(bl:Boolean):void {
			_is_exit_bl = bl;
			if (!bl) {
				contextMenu = _NODE_MENU;
			}
		}
		public function get exit():Boolean {
			return _is_exit_bl;
		}
		override public function set name(value:String):void {
			super.name = value;
			if (COLOR_GROUP.hasOwnProperty(name)) {
				_color = COLOR_GROUP[name];
			}
		}
		public function set status(bl:Boolean):void { 
			_is_static_bl = bl || _IS_FIXED_BL;
			if (_is_static_bl) {
				addChild(_label_txt);
			} else if (contains(_label_txt)) { 
				removeChild(_label_txt);
			}
		}
		public function get status():Boolean {
			return _is_static_bl;
		}
		
		/************
		 * methods
		 * *********/
		override protected function init():void {
			super.init();
			
			buttonMode = true;
			
			_connect = new Vector.<lineView>();
		}
		override public function mouseOnHandler(evt:MouseEvent = null, num:int = 0):void { 
			super.mouseOnHandler(evt);
			
			if (evt || num) {
				for each (var _line:lineView in _connect) {
					_line.mouseOnHandler(null, _count);
				}
				TweenLite.to(_bg_shape, .4, { scaleX:2, scaleY:2 } );
			}
			addChild(_label_txt);
		}
		override public function mouseOutHandler(evt:MouseEvent = null, num:int = 0):void { 
			super.mouseOutHandler(evt);
			
			if (evt || num) {
				for each (var _line:lineView in _connect) { 
					_line.mouseOutHandler();
				}
				TweenLite.to(_bg_shape, .4, { scaleX:1, scaleY:1 } );
			}
			if (!_is_static_bl && contains(_label_txt)) {
				removeChild(_label_txt);
			}
			
		}
		override public function draw():void {
			var _r:int = _RADIUS + _count / _UNIT;
			var _num:int = _r, _counter:int = 0;
			while (_num > 1) {
				_num *= .5;
				_counter++;
			}
			_num = Math.pow(2, _counter + 1);
			
			showLable();
			
			_bg_shape.graphics.clear();
			_bg_shape.graphics.lineStyle(2, 0xffffff, .5);
			_bg_shape.graphics.beginFill(_color);
			_bg_shape.graphics.drawCircle(0, 0, _r);
			_bg_shape.graphics.endFill();
			
			_filter = new GlowFilter(_color, 1, _num, _num);
			_bg_shape.filters = [_filter];
		}
		public function addConnectedLine(line:lineView):void {
			if ( -1 == _connect.indexOf(line)) {
				_connect.push(line);
			}
		}
		public function lightAllLine(bl:Boolean = true, evt:MouseEvent = null):void {
			for each (var _line:lineView in _connect) {
				if (bl) {
					_line.lc++;
				} else {
					_line.lc--;
					if (evt == null) {
						_line.mouseOutHandler();
					}
				}
			}
		}
		public function removeAllLines():void {
			_connect = new Vector.<lineView>();
		}
		public function show():void {
			visible = true;
			for each (var _line:lineView in _connect) {
				if (_line.to.visible && _line.from.visible) {
					_line.visible = true;
				}
			}
		}
		public function hide():void {
			// 暂时不移除值
			visible = false;
			for each (var _line:lineView in _connect) {
				_line.visible = false;
			}
		}
		override public function showLable():void {
			var total = columnView(parent).total;
			if (_IS_NUM_BL) {
				_label_txt.text = name + "(" + num + ")";
			} else if (total != 0) { 
				var _per:String = '';
				if (_is_exit_bl) {
					_per = Number(Math.round(_count / (total + _count) * 10000) * .01).toString();
				} else {
					_per = Number(Math.round(_count / total * 10000) * .01).toString();
				}
				_label_txt.text = name + "(" + _per.substr(0, 5) + "%)";
			}
			
			super.showLable();
		}
		
		/*********************
		 * static properties
		 * ******************/
		
		/*********************
		 * static functions
		 * ******************/
		private static function orderByHandler(evt:ContextMenuEvent):void {
			var _ball:ballView = ballView(evt.mouseTarget);
			var _y_arr:Vector.<int> = new Vector.<int>;
			var _next_arr:Vector.<lineView> = new Vector.<lineView>;
			for each (var _line:lineView in _ball.connected) {
				if (_line.from == _ball) {
					_y_arr.push(_line.to.y);
					_next_arr.push(_line);
				}
			}
			_next_arr.sort(function(_line1:lineView, _line2:lineView) { return _line2.num - _line1.num; } );
			_y_arr.sort(function(n1:int, n2:int) { return n1 - n2; } );
			
			var _counter:int = 0;
			for each (_line in _next_arr) {
				_line.to.y = _y_arr[_counter];
				for each (var _nline:lineView in _line.to.connected) {
					if (_nline.from == _line.to) {
						_nline.y = _line.to.y;
						_nline.lineTo(_nline.to.y - _nline.y);
						_nline.draw();
					} else {
						_nline.lineTo(_line.to.y - _nline.from.y);
						_nline.draw();
					}
				}
				_line.lineTo(_y_arr[_counter] - _ball.y);
				_line.draw();
				_counter += 1;
			}
		}
		private static function showDetail(evt:ContextMenuEvent):void {
			var _evt:mapEvent = new mapEvent(mapEvent.GET_NODE_DETAIL);
			_evt.ball = ballView(evt.mouseTarget);
			MAP.dispatchEvent(_evt);
		}
		private static function nodeFilter(evt:ContextMenuEvent):void {
			var _evt:mapEvent = new mapEvent(mapEvent.FILTER);
			_evt.ball = ballView(evt.mouseTarget);
			if (evt.target == _filterAgainItem) {
				_evt.reset = false;
			}
			MAP.dispatchEvent(_evt);
		}
		private static function hideNodeHandler(evt:ContextMenuEvent):void {
			ballView(evt.mouseTarget).hide();
		}
		
		/*********************
		 * static methods
		 * ******************/
		public static function nodeMenuInit():void {
			_NODE_MENU = new ContextMenu();
			_NODE_MENU.hideBuiltInItems();
			
			var _orderByItem:ContextMenuItem = new ContextMenuItem("按导出率多少顺序排列");
			_orderByItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, orderByHandler);
			_NODE_MENU.customItems.push(_orderByItem);
			var _showDetail:ContextMenuItem = new ContextMenuItem("显示详情");
			_showDetail.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showDetail);
			_NODE_MENU.customItems.push(_showDetail);
			
			_filterItem = new ContextMenuItem("过滤掉与此节点无关的点线", true);
			_filterItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, nodeFilter);
			_NODE_MENU.customItems.push(_filterItem);
			_filterAgainItem = new ContextMenuItem("继续过滤（保留上次的结果）");
			_filterAgainItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, nodeFilter);
			_NODE_MENU.customItems.push(_filterAgainItem);
			
			/*var _fixItem:ContextMenuItem = new ContextMenuItem("锁定常亮", true);
			_fixItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fixHandler);
			_NODE_MENU.customItems.push(_fixItem);*/
			var _hideItem:ContextMenuItem = new ContextMenuItem("隐藏节点", true);
			_hideItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, hideNodeHandler);
			_NODE_MENU.customItems.push(_hideItem);
		}
	}
}