package brunch.clickHeatMap.panel {
  import flash.display.DisplayObject;
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.text.TextField;
	import lib.component.numStepper.NumStepperBase;
	
	/**
   * 数字步进
   * @author Meathill
   */
  public class LowLimitStepper extends NumStepperBase {
    //=========================================================================
    // Class Static Constants
    //=========================================================================
    public static const HEIGHT:int = 17;
    //=========================================================================
    // Constructor
    //=========================================================================
    /**
     * create a instance of <code>LowLimitStepper</code>
     * @param	target
     */
    public function LowLimitStepper(target:Sprite) {
      super(SimpleButton(target.getChildAt(0)), 
            SimpleButton(target.getChildAt(1)),
            TextField(target.getChildAt(2)));
      autoSize = true;
      editable = false;
      this.target = target;
      this.triangle = target.getChildAt(3);
      draw();
    }
    //=========================================================================
    // Properties
    //=========================================================================
    override public function get x():Number {
      return target.x;
    }
    override public function set x(value:Number):void {
      target.x = value;
    }
    override public function get y():Number {
      return target.y;
    }
    override public function set y(value:Number):void {
      target.y = value;
    }
    override public function get value():int {
      return super.value;
    }
    override public function set value(num:int):void {
      super.value = num;
      plusButton.x = numTextField.x + numTextField.width + 1;
      draw();
      move();
    }
    public var left:int = 8;
    public var right:int = 214;
    public var bar:DisplayObject;
    // ========================================================================
    // Variables
    // ========================================================================
    private var target:Sprite;
    private var triangle:DisplayObject;
    //=========================================================================
    //  Override Protected Functions
    //=========================================================================
    override protected function changeNum(evt:MouseEvent):void {
      super.changeNum(evt);
      draw();
      move();
    }
    //=========================================================================
    // Protected Functions
    //=========================================================================
    protected function draw():void {
      target.graphics.clear();
      target.graphics.lineStyle(2, 0x333333);
      target.graphics.beginFill(0xFFFFFF);
      target.graphics.drawRoundRect(0, 5, plusButton.width + plusButton.x + 3, HEIGHT, 2, 2);
      target.graphics.endFill();
    }
    protected function move():void {
      var num:int = int(numTextField.text);
      x = (right - left - target.width) * (num - min)  / (max - min) + left;
      var pointTo:int = bar.width * (num - min) / (max - min) + bar.x;
      triangle.x = pointTo - (triangle.width >> 1) - x; 
    }
  }
}
