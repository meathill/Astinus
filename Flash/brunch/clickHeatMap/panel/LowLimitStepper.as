package brunch.clickHeatMap.panel {
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.text.TextField;
	import lib.component.numStepper.NumStepperBase;
	
	/**
   * 数字步进
   * @author Meathill
   */
  public class LowLimitStepper extends NumStepperBase {
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
    override public function set value(value:int):void {
      super.value = value;
      plusButton.x = numTextField.x + numTextField.width + 1;
      draw();
    }
    public var left:int = 5;
    public var right:int = 235;
    // ========================================================================
    // Variables
    // ========================================================================
    private var target:Sprite;
    //=========================================================================
    // Protected Functions
    //=========================================================================
    protected function draw():void {
      target.graphics.clear();
      target.graphics.lineStyle(2, 0x333333);
      target.graphics.beginFill(0xFFFFFF);
      target.graphics.drawRoundRect(0, 0, width + 4, height + 4, 3, 3);
      target.graphics.endFill();
    }
  }
}
