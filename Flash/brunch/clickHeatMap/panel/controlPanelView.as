package brunch.clickHeatMap.panel {
  import com.bit101.components.InputText;
  import com.bit101.components.Style;
  import effects.DisplayUtils;
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.FocusEvent;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.ui.Keyboard;
	
	/**
	 * 控制面板
	 * @author	Meathill
	 * @version	0.1(2011-02-22)
	 */
	public class controlPanelView extends Sprite {
    //=========================================================================
    // Constructor
    //=========================================================================
    /**
     * create a instance of <code>controlPanelView</code>
     */
		public function controlPanelView() {
			init();
		}
		//=========================================================================
    // Variables
    //=========================================================================
		private var maxTextField:TextField;
		private var colorbar:SimpleButton;
		private var stepper:LowLimitStepper;
		private var offsetX:InputText;
		private var offsetY:InputText;
    private var closeButton:SimpleButton;
		//=========================================================================
    // Properties
    //=========================================================================
		public function set max(num:int):void {
			maxTextField.text = num.toString();
			stepper.max = num;
			if (num > 0) {
				colorbar.mouseEnabled = true;
			}
		}
		public function set toX(num:int):void {
			offsetX.text = num.toString();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get toX():int {
			return int(offsetX.text);
		}
		public function set toY(num:int):void {
			offsetY.text = num.toString();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get toY():int {
			return int(offsetY.text);
		}
    public function get limit():int {
      return stepper.value;
    }
    public function set limit(value:int):void {
      stepper.value = value;
      stepper.max = value > stepper.max ? value : stepper.max;
      maxTextField.text = stepper.max.toString();
      setLevel();
    }
    public function set enabled(bl:Boolean):void {
      mouseChildren = mouseEnabled = bl;
      filters = bl ? null : [DisplayUtils.BLUR];
    }
    //=========================================================================
    // Private methods
    //=========================================================================
		private function init():void {
      closeButton = SimpleButton(getChildAt(numChildren - 1));
      closeButton.addEventListener(MouseEvent.CLICK, onClose);
      
			stepper = new LowLimitStepper(Sprite(getChildAt(numChildren-2)));
			stepper.addEventListener(Event.CHANGE, onStepperChange);
			
			maxTextField = TextField(getChildAt(numChildren - 3));
			maxTextField.mouseEnabled = false;
			
			colorbar = SimpleButton(getChildAt(numChildren - 4));
			colorbar.addEventListener(MouseEvent.CLICK, setLevel);
			colorbar.mouseEnabled = false;
			
			Style.BACKGROUND = 0xF1F1F1;
			offsetX = new InputText(this, 95, 120, '0');
			offsetY = new InputText(this, 158, 120, '0');
			offsetX.setSize(30, 20);
			offsetY.setSize(30, 20);
			offsetX.restrict = offsetY.restrict = '\-0-9';
      
      // 默认从点击数>2的绘制
      limit = 3;
      
      filters = [DisplayUtils.SHADOW];
			
			addEventListener(FocusEvent.FOCUS_IN, onFocus);
		}
		//=========================================================================
    // Public Methods
    //=========================================================================
    //=========================================================================
    // Event Handlers
    //=========================================================================
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
			//stepper.value = int((_tri_btn.x - colorbar.x + 6) / colorbar.width * int(maxTextField.text));
			//stepper.x = colorbar.width * _limit / int(maxTextField.text) + colorbar.x - 6 + 6 - (stepper.width >> 1);
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		private function onStepperChange(evt:Event):void {
			dispatchEvent(new Event(Event.RESIZE));
		}
    private function onClose(evt:MouseEvent):void {
      dispatchEvent(new Event(Event.CLOSE));
    }
	}
}