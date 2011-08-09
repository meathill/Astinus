package brunch.clickHeatMap.view 
{
	import brunch.clickHeatMap.model.dataModel;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 绘图类
	 * @author	Meathill
	 * @version	0.1(2011-02-21)
	 */
	public class mapView extends Sprite
	{
		public static const RATE:int = 512;
		
		public var data:dataModel;
		
		private const _HEAT:uint = 0x99000000;
		
		private var _heat_area:BitmapData;
		private var _bmp:Bitmap;
		private var _data_arr:Vector.<Array>;
		private var _tips:curLinkTips;
		private var _mid:int = 0;
		private var _total:int = 0;
		private var _ori_x:int = 0, _ori_y:int = 0;
		private var _width:int = 0, _height:int = 0;
		
		public function mapView(w:int = 100, h:int = 100) 
		{
			init(w, h);
		}
		
		/************
		 * properties
		 * *********/
		public function set limit(num:int):void {
			var _count:int = data.total - 1;
			while (_count > 0 && data.top[_count][4] < num) {
				_count--;
			}
			_data_arr = data.top.slice(0, _count + 1);
			if (_data_arr.length != _total) {
				_heat_area.dispose();
				_heat_area = new BitmapData(_width, _height, true, 0);
				_bmp.bitmapData = _heat_area;
				addEventListener(Event.ENTER_FRAME, drawing);
			}
		}
		override public function get width():Number { 
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			super.width = value;
		}
		
		/************
		 * functions
		 * *********/
		private function init(w:int, h:int):void {
			_width = w, _height = h;
			_tips = curLinkTips(removeChildAt(0));
			
			_heat_area = new BitmapData(w, h, true, 0);
			_bmp = new Bitmap(_heat_area);
			addChild(_bmp);
			
			// 画个背景
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		private function drawing(evt:Event):void {
			var _time:int = getTimer();
			_heat_area.lock();
			while (getTimer() - _time < 25 && _data_arr.length > 0) {
				for (var i:int = 0, ilen:int = Math.min(RATE, _data_arr.length); i < ilen; i += 1) { 
					var _arr:Array = _data_arr.pop();
					var _rect:Rectangle = new Rectangle(_arr[0], _arr[1], _arr[2], _arr[3]);
					var _color:uint = _HEAT;
					if (_arr[4] < _mid) {
						_color += ((_mid - _arr[4]) / _mid * 0xff << 16) + ((_mid - _arr[4]) / _mid * 0xff << 8) + 0xff;
					} else if (_arr[4] < _mid * 1.33) {
						_color += ((_arr[4] - _mid) / _mid * 3) * 0xfe01 + 0xff;
					} else if (_arr[4] < _mid * 1.67) {
						_color += 0x00ff00 + ((_arr[4] - _mid * 1.33) / _mid * 3 * 0xff << 16);
					} else {
						_color += 0xffff00 - ((_arr[4] - _mid * 1.67) / _mid * 3 * 0xff << 8);
					}
					_heat_area.fillRect(_rect, _color);
				}
			}
			_heat_area.unlock();
			if (_data_arr.length == 0) {
				removeEventListener(Event.ENTER_FRAME, drawing);
				dispatchEvent(new Event(Event.COMPLETE));
				
				addEventListener(Event.ENTER_FRAME, onMouseMove);
				addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			}
		}
		private function onMouseMove(evt:Event):void {
			var _touch:Vector.<Array> = data.getRectList(mouseX, mouseY, 0, 0, 1);
			if (_touch.length > 0) {
				var _arr:Array = _touch[0];
				_tips.x = _arr[0], _tips.y = _arr[1];
				_tips.setContent(_arr[5], _arr[4], _arr[2], _arr[3]);
				addChildAt(_tips, 1);
			} else if (contains(_tips)) {
				removeChild(_tips);
			}
		}
		private function startDraw(evt:MouseEvent):void {
			if (contains(_tips)) {
				removeChild(_tips);
			}
			removeEventListener(Event.ENTER_FRAME, onMouseMove);
			addEventListener(MouseEvent.MOUSE_MOVE, onDrawing);
			addEventListener(MouseEvent.MOUSE_UP, stopDraw);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraw);
			
			var _area:drawingArea = new drawingArea();
			_area.isCur = true;
			if (evt.target == this) {
				_ori_x = _area.x = evt.localX, _ori_y = _area.y = evt.localY;
			} else {
				
			}
			addChild(_area);
		}
		private function onDrawing(evt:MouseEvent):void {
			drawingArea.cur.setSize(evt.localX - _ori_x >> 0, evt.localY - _ori_y >> 0);
			drawingArea.cur.x = evt.localX < _ori_x ? evt.localX : _ori_x;
			drawingArea.cur.y = evt.localY < _ori_y ? evt.localY : _ori_y;
		}
		private function stopDraw(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, onDrawing);
			removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			
			if (Math.abs(evt.localX - _ori_x) > 20 && Math.abs(evt.localY - _ori_y) > 20) {
				drawingArea.cur.fixed = true;
				
				// 取覆盖的区块的数据
				var _touch:Vector.<Array> = data.getRectList(drawingArea.cur.x, drawingArea.cur.y, drawingArea.cur.width, drawingArea.cur.height);
				var _total:int = 0;
				for (var i:int = 0, len:int = _touch.length; i < len; i += 1) {
					_total += _touch[i][4];
				}
				drawingArea.cur.setNum(_total, _total / data.hits);
				drawingArea.cur.detail = _touch;
			} else {
				removeChild(drawingArea.cur);
				if (getChildAt(numChildren - 1) is drawingArea) {
					drawingArea(getChildAt(numChildren - 1)).isCur = true;
				}
			}
			
			addEventListener(Event.ENTER_FRAME, onMouseMove);
		}
		
		/************
		 * methods
		 * *********/
		public function draw(arr:Vector.<Array>, max:int = 0):void {
			_mid = max >> 1;
			_total = arr.length;
			_data_arr = arr;
			addEventListener(Event.ENTER_FRAME, drawing);
		}
	}
}