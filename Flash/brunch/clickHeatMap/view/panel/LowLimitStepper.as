package brunch.clickHeatMap.view.panel {
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.text.TextField;
	import lib.component.numStepper.NumStepperBase;
	
	/**
   * 数值步进器
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
      this.target = target;
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
    // ========================================================================
    // Variables
    // ========================================================================
    private var target:Sprite;
  }
}