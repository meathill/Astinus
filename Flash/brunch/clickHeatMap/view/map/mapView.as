package brunch.clickHeatMap.view.map 
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
		public static const RATE:int = 256;
		public static const MAX_WIDTH:int = 1680;
		public static const MAX_HEIGHT:int = 8000;
		
		public var data:dataModel;
		
		private const _HEAT:uint = 0x99000000;
		
		private var _heat_area:BitmapData;
		private var _bmps:Array;
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
			if (_count + 1 != _total) {
				draw(data.top.slice(0, _count + 1));
			}
		}
		override public function get width():Number { 
			return _width;
		}
		
		/************
		 * functions
		 * *********/
		private function init(w:int, h:int):void {
			_width = w, _height = h;
			_tips = curLinkTips(removeChildAt(0));
			
			// 如果高度大于最大高度，那么建立一个数组来存储所有位图
			_bmps = [];
			for (var i:int = 0, len:int = Math.ceil(h / MAX_HEIGHT); i < len; i += 1) {
				_heat_area = new BitmapData(w, h > MAX_HEIGHT? MAX_HEIGHT : h, true, 0);
				_bmp = new Bitmap(_heat_area);
				_bmp.y = MAX_HEIGHT * i;
				addChild(_bmp);
				_bmps[i] = _bmp;
				h -= MAX_HEIGHT;
			}
		}
		private function drawing(evt:Event):void {
			var _time:int = getTimer();
			for each (var _bmp:Bitmap in _bmps) {
				_bmp.bitmapData.lock();
			}
      // 因为最后一截总是算国界，导致最高的颜色不是红色而是黄色
      // 所以限制最大不超过0xFF00
      var tmpColor:uint = 0;
			while (getTimer() - _time < 25 && _data_arr.length > 0) {
				for (var i:int = 0, ilen:int = _data_arr.length < RATE ? _data_arr.length : RATE; i < ilen; i += 1) { 
					var _arr:Array = _data_arr.pop();
					var _color:uint = _HEAT;
					if (_arr[4] < _mid) {
						_color += ((_mid - _arr[4]) / _mid * 0xff << 16) + ((_mid - _arr[4]) / _mid * 0xff << 8) + 0xFF;
					} else if (_arr[4] < _mid * 1.33) {
						_color += ((_arr[4] - _mid) / _mid * 3) * 0xfe01 + 0xFF;
					} else if (_arr[4] < _mid * 1.66) {
						_color += 0x00ff00 + ((_arr[4] - _mid * 1.33) / _mid * 3 * 0xFF << 16);
					} else {
            tmpColor = (_arr[4] - _mid * 1.66) / _mid * 3 * 0xFF << 8;
						_color += 0xFFFF00 - (0xFF00 < tmpColor ? 0xFF00 : tmpColor);
					}
					for (var j:int = _arr[1] / MAX_HEIGHT >> 0, len:int = Math.ceil((_arr[1] + _arr[3]) / MAX_HEIGHT); j < len; j += 1) { 
						var _rect:Rectangle = new Rectangle(_arr[0], _arr[1] - MAX_HEIGHT * j, _arr[2], _arr[3] > MAX_HEIGHT * (j + 1) ? MAX_HEIGHT * (j + 1) : _arr[3]);
						_heat_area = Bitmap(_bmps[j]).bitmapData;
						_heat_area.fillRect(_rect, _color);
					}
				}
			}
			for each (_bmp in _bmps) {
				_bmp.bitmapData.unlock();
			}
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
				addChildAt(_tips, _bmps.length);
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
			_ori_x = _area.x = evt.localX, _ori_y = _area.y = evt.localY;
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
		public function draw(arr:Vector.<Array>, max:int = 0, min:int = 0):void {
			if (max > 0) {
				_mid = max >> 1;
			}
      if (min > 0) {
        limit = min;
      } else {
        // 更新bmpd
        for each (_bmp in _bmps) {
          _heat_area = new BitmapData(_bmp.width, _bmp.height, true, 0);
          _bmp.bitmapData.dispose();
          _bmp.bitmapData = _heat_area;
        }
        _total = arr.length;
        _data_arr = arr;
        addEventListener(Event.ENTER_FRAME, drawing);
      }
		}
	}
}