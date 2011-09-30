package brunch.clickHeatMap.map.area {
  import flash.events.MouseEvent;
	/**
   * 使用html来展示数据
   * @author Meathill
   */
  public class HTMLDrawingArea extends DrawingAreaBase {
    //==========================================================================
    //  Override Properties : DrawingAreaBase
    //==========================================================================
    
    //==========================================================================
    //  Override Protected Functions : DrawingAreaBase
    //==========================================================================
    override protected function init():void {
      super.init();
      
      hideButton.removeEventListener(MouseEvent.CLICK, toggleList);
    }
    override protected function closeHandler(evt:MouseEvent = null):void {
      super.closeHandler(evt);
      external.removeDetail(index);
    }
    override protected function onClick(evt:MouseEvent):void {
      evt.stopImmediatePropagation();
      external.showDetail(index);
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