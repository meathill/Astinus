package src.view.ui 
{
  import com.greensock.TweenLite;
  import flash.display.SimpleButton;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import lib.component.window.windowBaseView;
	
	/**
	 * 显示节点详细数据
	 * @author Meathill
	 */
	public class commonWindowView extends windowBaseView
	{
		public function commonWindowView() 
		{
			init();
		}
		
		/**************
		 * properties
		 * ***********/
		
		/***************
		 * functions
		 * ************/
		private function init():void {
			alpha = 0;
			
			_title_bar = SimpleButton(getChildAt(0));
			_close_btn = SimpleButton(getChildAt(1));
			_title_txt = TextField(getChildAt(2));
			_title_txt.selectable = false;
			_title_txt.mouseEnabled = false;
			
			controlsInit();
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		protected function addedHandler(evt:Event):void {
			fadeIn();
		}
		override protected function closeHandler(evt:MouseEvent = null):void {
			visible = false;
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		/***************
		 * methods
		 * ************/
		override public function fadeIn(evt:Event = null):void {
			y += 20;
			visible = true;
			TweenLite.to(this, .4, { alpha:1, y:y - 20 } );
		}
		override public function fadeOut(evt:Event = null):void {
			TweenLite.to(this, .4, { alpha:0, y:y + 20, onComplete:closeHandler } );
		}
		
		/***************
		 * static methods
		 * ************/
	}
}