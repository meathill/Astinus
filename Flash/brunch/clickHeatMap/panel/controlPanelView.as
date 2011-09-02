package brunch.clickHeatMap.panel {
  import com.adobe.utils.ArrayUtil;
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
	public class ControlPanelView extends Sprite {
    //=========================================================================
    // Class Static Constants
    //=========================================================================
    public static const WIDTH:int = 220;
    //=========================================================================
    // Constructor
    //=========================================================================
    /**
     * create a instance of <code>ControlPanelView</code>
     */
		public function ControlPanelView() {
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
      if (value > int(maxTextField.text)) {
        return ;
      }
      stepper.value = value;
    }
    public function set enabled(bl:Boolean):void {
      mouseChildren = mouseEnabled = bl;
      filters = bl ? null : [DisplayUtils.BLUR];
    }
    //=========================================================================
    // Private methods
    //=========================================================================
		private function init():void {
      /*for (var i:int = 0; i < numChildren; i++) {
        trace(i, getChildAt(i).x + getChildAt(i).width);
      }*/
      closeButton = SimpleButton(getChildAt(numChildren - 1));
      closeButton.addEventListener(MouseEvent.CLICK, onClose);
			
			maxTextField = TextField(getChildAt(numChildren - 3));
			maxTextField.mouseEnabled = false;
			
			colorbar = SimpleButton(getChildAt(numChildren - 4));
			colorbar.addEventListener(MouseEvent.CLICK, setLevel);
			colorbar.mouseEnabled = false;
      
			stepper = new LowLimitStepper(Sprite(getChildAt(numChildren - 2)));
      stepper.bar = colorbar;
			stepper.addEventListener(Event.CHANGE, onStepperChange);
			
			Style.BACKGROUND = 0xF1F1F1;
			offsetX = new InputText(this, 95, 120, '0');
			offsetY = new InputText(this, 158, 120, '0');
			offsetX.setSize(30, 20);
			offsetY.setSize(30, 20);
			offsetX.restrict = offsetY.restrict = '\-0-9';
      
      // 默认从点击数>2的绘制
      limit = 3;
			
      onRemoved();
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
					toY += evt.ctrlKey ? 10 : 1;
					break;
			}
		}
    private function onAdded(evt:Event = null):void {
      /*stage.focus = this;
      stage.focusRect = null;*/
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      addEventListener(Event.REMOVED, onRemoved);
      removeEventListener(Event.ADDED_TO_STAGE, onAdded);
    }
    private function onRemoved(evt:Event = null):void {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      addEventListener(Event.REMOVED, onAdded);
      removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }
		private function setLevel(evt:MouseEvent = null):void {
			stepper.value = evt.localX / colorbar.width * int(maxTextField.text);
			
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