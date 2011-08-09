package src.view 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import src.model.IDataMap;
	import src.view.element.ballView;
	import src.view.element.elementBasicView;
	import src.view.element.lineView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class mapView extends Sprite implements IDataMap
	{
		public var length:int = 0;
		
		private var _line_container:Sprite;
		private var _drag_rect:Rectangle;
		private var _node_name_arr:Vector.<String> = new Vector.<String>;
		private var _max_nodes:int = 0;
		private var _extra_height:int = 0;
		private var _max:int = 0;
		private var _min:int = 10;
		private var _is_light_bl:Boolean = false;
		
		public function mapView() 
		{
			init();
		}
		
		/***************
		 * properties
		 * ************/
		public function get max():int {
			return _max;
		}
		public function get min():int {
			return _min;
		}
		public function set isLight(bl:Boolean):void {
			_is_light_bl = bl;
		}
		public function get nodeNameList():Vector.<String> {
			return _node_name_arr;
		}
		
		/***************
		 * functions
		 * ************/
		private function init():void {
			_line_container = new Sprite();
			addChild(_line_container);
		}
		private function getLineName(item1:DisplayObject, item2:DisplayObject):String {
			return item1.name + "#" + item1.parent.name + "_" + item2.name + "#" + item2.parent.name;
		}
		private function dragStart(evt:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			addEventListener(MouseEvent.MOUSE_UP, dragStop);
			
			startDrag(false, _drag_rect);
		}
		private function dragStop(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			
			stopDrag();
		}
		private function recordNodeName(str:String):void {
			if ( -1 == _node_name_arr.indexOf(str)) {
				_node_name_arr.push(str);
			}
		}
		private function addItemAt(item:ballView, x:int):void {
			var _column:columnView;
			if (numChildren - 2 < x) {
				_column = new columnView();
				_column.name = "c" + x.toString();
				_column.x = columnView.WIDTH * x;
				addChild(_column);
			} else {
				_column	= columnView(getChildAt(x + 1));
			}
			item.x = columnView.WIDTH / 2;
			item.y = (_column.numChildren - 1) * columnView.SPACE + 10;
			_column.addChild(item);
			_max_nodes = Math.max(_column.numChildren - 2, _max_nodes);
		}
		private function addLineBetween(item1:ballView, item2:ballView, line:lineView):void {
			line.name = getLineName(item1, item2);
			line.from = item1;
			line.to = item2;
			item1.addConnectedLine(line);
			item2.addConnectedLine(line);
			_line_container.addChild(line);
		}
		private function checkItemExist(caption:String, x:int):ballView {
			var _result:ballView = null;
			if (x < numChildren - 1) { 
				var _column:columnView = columnView(getChildAt(x + 1));
				_result = ballView(_column.getChildByName(caption));
			}
			return _result;
		}
		private function checkLineExist(item1:ballView, item2:ballView):lineView {
			var _line_name:String = getLineName(item1, item2);
			var _result:lineView = null;
			_result = lineView(_line_container.getChildByName(_line_name));
			return _result;
		}
		
		/***************
		 * methods
		 * ************/
		public function drawMap(arr:Array):void {
			columnView.WIDTH = stage.stageWidth / length > columnView.MIN_WIDTH ? stage.stageWidth / length : columnView.MIN_WIDTH;
			lineView.SPACE = columnView.WIDTH;
			elementBasicView.init();
			columnView.init();
			empty();
			
			for (var i:int = 0, len:int = arr.length; i < len; i += 1) { 
				var _arr:Array = arr[i];
				var _count:int = _arr.length;
				var _cur:ballView = null;
				var _num:int = _arr[_arr.length - 1];
				for (var j:int = 0; j < _arr.length - 1; j+=1) { 
					var _now:ballView = addItem(_arr[j], j, _num);
					if (_cur) {
						addLine(_cur, _now, _num);
					}
					_cur = _now;
					
					// 把节点名称记录下来
					recordNodeName(_arr[j]);
				}
				
				// 如果中断了，就要加上跳出
				if (_arr.length - 1 < length) { 
					var _exit:ballView = addItem('跳出', j, _num, true);
					addLine(_cur, _exit, _num);
				}
			}
			
			elementBasicView.UNIT = Math.round(_max / 20) > 0 ? Math.round(_max / 20) : 1;
			elementBasicView.itemsInit();
			if (_is_light_bl) {
				elementBasicView.lightAllNodes();
			}
			columnView.itemsInit();
			dragBg();
		}
		public function addItem(content:String, index:int, num:int = 0, bl:Boolean = false):ballView { 
			var _item:ballView = checkItemExist(content, index);
			if (_item != null) { 
				_item.num += num;
			} else {
				// 画图
				var _mc:ballView = new ballView();
				_mc.exit = bl;
				_mc.name = content;
				_mc.num = num;
				
				addItemAt(_mc, index);
				
				_item = _mc;
			}
			_max = _item.num > _max ? _item.num : _max;
			_min = _item.num < _min ? _item.num : _min;
			return _item;
		}
		public function addLine(from:ballView, to:ballView, num:int = 0):void {
			var _oline:lineView = lineView(checkLineExist(from, to));
			if (_oline != null) { 
				_oline.num += num;
			} else {
				var _line:lineView = new lineView();
				_line.x = from.x + from.parent.x;
				_line.y = from.y + from.parent.y;
				_line.num = num;
				_line.lineTo(to.y - from.y);
				
				addLineBetween(from, to, _line);
			}
		}
		public function getItemByIndex(caption:String, x:int):DisplayObject {
			var _column:columnView = columnView(getChildAt(x + 1));
			return _column.getChildByName(caption);
		}
		public function showAll():void {
			for (var i:int = 1; i < numChildren; i++) {
				columnView(getChildAt(i)).clickHandler();
			}
		}
		/**
		 * 清空所有元素
		 * @param	bl 是否清除除特殊数组之外的元素
		 */
		public function empty():void {
			while (numChildren > 1) { 
				var _column:columnView = columnView(getChildAt(1));
				while (_column.numChildren > 2) {
					var _ball:ballView = ballView(_column.getChildAt(2));
					_ball.removeAllLines();
					_column.removeChild(_ball);
				}
				removeChild(_column);
			}
			while (_line_container.numChildren) {
				var _line:lineView = lineView(_line_container.getChildAt(0));
				_line.removeEnds();
				_line_container.removeChild(_line);
			}
			_node_name_arr = new Vector.<String>;
		}
		public function dragBg():void {
			graphics.clear();
			if (columnView.WIDTH * (numChildren - 1) > stage.stageWidth || columnView.MAX_ITEM * columnView.SPACE > stage.stageHeight) {
				graphics.beginFill(0x000000);
				graphics.drawRect(0, 0, columnView.WIDTH * (numChildren - 1), columnView.MAX_ITEM * columnView.SPACE);
				graphics.endFill();
				
				_drag_rect =  new Rectangle(0, 30, stage.stageWidth - columnView.WIDTH * (numChildren - 1), stage.stageHeight - columnView.MAX_ITEM * columnView.SPACE);
			
				addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			}
		}
	}
}