package brunch.clickHeatMap.controller {
  import brunch.clickHeatMap.clickHeatMapMain;
  import effects.DisplayUtils;
  import flash.events.Event;
	/**
   * 使用静态函数控制界面
   * @author Meathill
   * @version 0.1(2011-08-31)
   */
  public class GUI {
    //=========================================================================
    // Class Variables
    //=========================================================================
    public static var main:clickHeatMapMain;
    //=========================================================================
    // Class Public Methods
    //=========================================================================
    public static function switchButtonPanel(evt:Event):void {
      DisplayUtils.toggleMC(main.helpButton, main.optionsPanel);
    }
  }
}