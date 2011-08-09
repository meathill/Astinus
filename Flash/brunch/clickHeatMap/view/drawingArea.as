package brunch.clickHeatMap.view 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 绘制区域示意图
	 * @author	Meathill
	 * @version	0.1(2011-02-24)
	 */
	public class drawingArea extends Sprite
	{
		public static const PANEL_WIDTH:int = 300;
		public static const PANEL_HEIGHT:int = 300;
		
		public static var cur:drawingArea;
		
		private var _width:int = 10;
		private var _height:int = 10;
		private var _close_btn:SimpleButton;
		private var _hide_btn:SimpleButton;
		private var _num_txt:TextField;
		private var _panel:dataPanel;
		
		public function drawingArea() 
		{
			init();
		}
		
		/************
		 * properties
		 * *********/
		public function set isCur(bl:Boolean):void {
			if (bl) {
				if (cur != null && cur != this) {
					cur.isCur = false;
				}
				cur = this;
			}
			setSize();
		}
		public function get isCur():Boolean {
			return cur == this;
		}
		public function set fixed(bl:Boolean):void {
			if (bl) {
				_close_btn.x = _width - 20;
				addChild(_close_btn);
			} else {
				removeChild(_close_btn);
			}
			mouseChildren = mouseEnabled = bl;
		}
		public function set detail(arr:Vector.<Array>):void {
			if (null == _panel) {
				_panel = new dataPanel(this, _width + 16);
				_panel.setSize(PANEL_WIDTH, _height > PANEL_HEIGHT ? _height : PANEL_HEIGHT);
				_panel.pos = [x, y, _width, _height];
			}
			var _list_arr:Array = [];
			for (var i:int = 0, len:int = arr.length; i < len; i += 1) {
				_list_arr[i] = arr[i][4] + ' | ' + arr[i][5];
			}
			_panel.url = _list_arr;
			
			// 隐藏按钮
			_hide_btn.x = _width + 4, _hide_btn.y = _height - _hide_btn.height >> 1;
			addChild(_hide_btn);
			
			// 基于当前坐标的特殊处理
			if (stage.stageWidth - x - _width < PANEL_WIDTH + 16) {
				_panel.x = - PANEL_WIDTH - 16;
				_hide_btn.x = -4;
				_hide_btn.scaleX = -_hide_btn.scaleX;
				if (x < PANEL_WIDTH + 16) {
					_hide_btn.x = 4, _hide_btn.scaleX = 1;
					_panel.x = 16, _panel.y = 12;
					_panel.setSize(PANEL_WIDTH, _height > PANEL_HEIGHT ? _height : PANEL_HEIGHT);
				}
			}
		}
		override public function get width():Number {
			return _width;
		}
		override public function get height():Number {
			return _height;
		}
		
		/************
		 * functions
		 * *********/
		private function init():void {
			mouseChildren = mouseEnabled = false;
			
			_close_btn = removeChildAt(0) as SimpleButton;
			_close_btn.addEventListener(MouseEvent.CLICK, closeHandler);
			
			_hide_btn = removeChildAt(0) as SimpleButton;
			_hide_btn.addEventListener(MouseEvent.CLICK, toggleList);
			
			_num_txt = removeChildAt(0) as TextField;
			_num_txt.mouseEnabled = false;
			_num_txt.autoSize = TextFieldAutoSize.CENTER;
			
			addEventListener(MouseEvent.MOUSE_DOWN, stopPropagation);
		}
		private function closeHandler(evt:MouseEvent):void {
			evt.stopImmediatePropagation();
			parent.removeChild(this);
		}
		private function stopPropagation(evt:MouseEvent):void {
			evt.stopPropagation();
		}
		private function toggleList(evt:MouseEvent):void {
			_hide_btn.x += 8 * _hide_btn.scaleX;
			_hide_btn.scaleX = -_hide_btn.scaleX;
			_panel.visible = !_panel.visible;
		}
		
		/************
		 * methods
		 * *********/
		public function setSize(w:int = 0, h:int = 0):void {
			// 下面这俩货是取绝对值的哟
			if (w != 0)	_width = (w ^ (w >> 31)) - (w >> 31);
			if (h != 0) _height = (h ^ (h >> 31)) - (h >> 31);
			graphics.clear();
			if (isCur) {
				graphics.lineStyle(4, 0xffffff, .6);
				graphics.beginFill(0x336699, .4);
			} else {
				graphics.lineStyle(2, 0xffffff, .6);
				graphics.beginFill(0x666666, .4);
			}
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		public function setNum(num:int, per:Number):void {
			_num_txt.text = num + '(' + int(per * 10000) / 100 + '%)';
			_num_txt.x = _width - _num_txt.width >> 1;
			_num_txt.y = _height - _num_txt.height >> 1;
			addChild(_num_txt);
		}
	}
}