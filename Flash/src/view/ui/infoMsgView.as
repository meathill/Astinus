package src.view.ui 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class infoMsgView extends Sprite
	{
		private var _txt:TextField;
		private var _timer:Timer;
		
		public function infoMsgView() 
		{
			init();
		}
		
		/*************
		 * properties
		 * **********/
		public function set text(str:String):void {
			_txt.text = str;
			_timer.stop();
			show();
		}
		public function get text():String {
			return _txt.text;
		}
		
		/*************
		 * functions
		 * **********/
		private function init():void {
			_txt = TextField(getChildAt(1));
			
			_timer = new Timer(8000);
			_timer.addEventListener(TimerEvent.TIMER, hide);
			
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		private function addedHandler(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			hide();
		}
		private function timeStart():void {
			_timer.reset();
			_timer.start();
		}
		
		/***********
		 * methods
		 * ********/
		public function hide(evt:Event = null):void {
			TweenLite.to(this, .6, { x:stage.stageWidth - width + 50 } );
		}
		public function show(evt:Event = null):void {
			TweenLite.to(this, .6, { x:stage.stageWidth - width - 5, onComplete:timeStart } );
		}
	}
}