package brunch.clickHeatMap.controller {
  import brunch.clickHeatMap.ClickHeatMapMain;
  import com.greensock.TweenLite;
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
    public static var main:ClickHeatMapMain;
    //=========================================================================
    // Class Public Methods
    //=========================================================================
    public static function switchButtonPanel(evt:Event):void {
      if (main.contains(main.helpButton)) {
        main.addChild(main.optionsPanel);
        TweenLite.to(main.optionsPanel, .6, { x: main.stage.stageWidth - main.optionsPanel.width } );
        main.removeChild(main.helpButton);
      } else if (main.contains(main.optionsPanel)) {
        TweenLite.to(main.optionsPanel, .6, { x:main.stage.stageWidth, onComplete: OnButtonSwitched } );
        
      }
    }
    //=========================================================================
    // Class Private Functions
    //=========================================================================
    private static function OnButtonSwitched():void {
      main.removeChild(main.optionsPanel);
      main.addChild(main.helpButton);
    }
  }
}