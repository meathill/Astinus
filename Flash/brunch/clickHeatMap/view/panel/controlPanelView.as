package brunch.clickHeatMap.view.panel 
{
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton
	import com.bit101.components.Style;
	import com.greensock.TweenLite;
  import effects.DisplayUtils;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import lib.component.numStepper.numStepper;
	
	/**
	 * 控制面板
	 * @author	Meathill
	 * @version	0.1(2011-02-22)
	 */
	public class controlPanelView extends Sprite
	{
		private var _limit:int = 0;
		private var _max:TextField;
		private var _colorbar:SimpleButton;
		private var _tri_btn:Sprite;
		private var _num:numStepper;
		private var _x_txt:InputText;
		private var _y_txt:InputText;
		
		public function controlPanelView() 
		{
			init();
		}
		
		/************
		 * properties
		 * *********/
		public function set max(num:int):void {
			_max.text = num.toString();
			_num.max = num;
			if (num > 0) {
				_colorbar.mouseEnabled = _tri_btn.mouseEnabled = true;
			}
		}
		public function set toX(num:int):void {
			_x_txt.text = num.toString();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get toX():int {
			return int(_x_txt.text);
		}
		public function set toY(num:int):void {
			_y_txt.text = num.toString();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get toY():int {
			return int(_y_txt.text);
		}
    public function get limit():int {
      return _limit;
    }
    public function set limit(value:int):void {
      _limit = value;
      _num.value = value;
      _num.max = value > _num.max ? value : _num.max;
      _max.text = _num.max.toString();
      setLevel();
    }
    
		
		/************
		 * functions
		 * *********/
		private function init():void {
			_num = new numStepper(_plus_btn, _reduce_btn, _num_txt);
			_num.editable = false;
			_num.autoSize = true;
			_num.addEventListener(Event.CHANGE, onStepperChange);
			
			_max = getChildAt(7) as TextField;
			_max.mouseEnabled = false;
			
			_colorbar = getChildAt(6) as SimpleButton;
			_colorbar.addEventListener(MouseEvent.CLICK, setLevel);
			_colorbar.mouseEnabled = false;
			
			_tri_btn = getChildAt(5) as Sprite;
			_tri_btn.mouseChildren = _tri_btn.mouseEnabled = false;
			_tri_btn.buttonMode = true;
			_tri_btn.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			
			Style.BACKGROUND = 0xffffff;
			_x_txt = new InputText(this, 120, 80, '0');
			_y_txt = new InputText(this, 180, 80, '0');
			_x_txt.setSize(30, 20);
			_y_txt.setSize(30, 20);
			_x_txt.restrict = _y_txt.restrict = '\-0-9';
      
      // 默认从点击数>2的绘制
      limit = 3;
      
      filters = [DisplayUtils.SHADOW];
			
			addEventListener(FocusEvent.FOCUS_IN, onFocus);
		}
		private function onKeyDown(evt:KeyboardEvent):void {
			switch(evt.keyCode) {
				case Keyboard.LEFT:
					toX -= evt.ctrlKey ? 10 : 1;
					break;
				case Keyboard.RIGHT:
					toX += evt.ctrlKey ? 10 : 1;
					break;
				case Keyboard.UP:
					toY -= evt.ctrlKey ? 10 : 1;
					break;
				case Keyboard.DOWN:
					toY += evt.ctrlKey ? 10:1;
					break;
			}
		}
		private function onFocus(evt:Event):void {
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		private function setLevel(evt:MouseEvent = null):void {
			if (evt != null) {
				_tri_btn.x = evt.localX - 6 + _colorbar.x;
			}
			_limit = int((_tri_btn.x - _colorbar.x + 6) / _colorbar.width * int(_max.text));
			_tri_btn.x = _colorbar.width * _limit / int(_max.text) + _colorbar.x - 6;
			_num.value = _limit;
			_num.x = _tri_btn.x + 6 - (_num.width >> 1);
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		private function dragStart(evt:MouseEvent):void {
			_tri_btn.startDrag(false, new Rectangle(24, 18, 180));
			_tri_btn.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			addEventListener(Event.ENTER_FRAME, onDraging);
		}
		private function onDraging(evt:Event):void {
			_num.value = int((_tri_btn.x - _colorbar.x + 6) / _colorbar.width * int(_max.text));
			_num.x = _tri_btn.x + 6 - (_num.width >> 1);
		}
		private function dragStop(evt:MouseEvent):void {
			_tri_btn.stopDrag();
			_tri_btn.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			removeEventListener(Event.ENTER_FRAME, onDraging);
			
			setLevel();
		}
		private function onStepperChange(evt:Event):void {
			_tri_btn.x = _num.value / int(_max.text) * _colorbar.width + _colorbar.x - 6;
			_num.x = _tri_btn.x + 6 - (_num.width >> 1);
			_limit = _num.value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/************
		 * methods
		 * *********/
		public function toggleHelp(evt:MouseEvent = null):void {
			if (visible) {
				TweenLite.to(this, .6, { alpha:0, y:35, onComplete:function() { visible = false } } );
			} else {
				visible = true;
				TweenLite.to(this, .6, { alpha:1, y:45 } );
			}
		}
	}
}