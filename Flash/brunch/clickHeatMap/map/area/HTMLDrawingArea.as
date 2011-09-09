package brunch.clickHeatMap.map.area {
  import flash.events.MouseEvent;
	/**
   * 使用html来展示数据
   * @author Meathill
   */
  public class HTMLDrawingArea extends DrawingAreaBase {
    //==========================================================================
    //  Override Protected Functions : DrawingAreaBase
    //==========================================================================
    override protected function init():void {
      super.init();
      
      hideButton.removeEventListener(MouseEvent.CLICK, toggleList);
      removeChild(hideButton);
      hideButton = null;
    }
    override protected function closeHandler(evt:MouseEvent = null):void {
      super.closeHandler(evt);
      external.removeDetail(index);
    }
    //==========================================================================
    //  Override Public Methods : DrawingAreaBase
    //==========================================================================
    override public function set detail(value:Vector.<Array>):void {
      super.detail = value;
      external.removeDetail(index);
    }
  }
}