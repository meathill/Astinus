package src.event 
{
	import flash.events.Event;
	import src.view.element.lineView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class adjustEvent extends Event 
	{
		public static const ADJUST:String = "adjust";
		
		private var _num:int;
		private var _line:lineView;
		
		public function adjustEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		}
		
		/************
		 * properties
		 * *********/
		public function set num(n:int):void {
			_num = n;
		}
		public function get num():int {
			return _num;
		}
		public function set line(fo:lineView):void {
			_line = fo;
		}
		public function get line():lineView {
			return _line;
		}
		
		/*************
		 * methods
		 * **********/
		public override function clone():Event { 
			return new adjustEvent(type, bubbles, cancelable);
		}
		public override function toString():String { 
			return formatToString("adjustEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}