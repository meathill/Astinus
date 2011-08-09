package src.event 
{
	import flash.events.Event;
	import src.view.element.ballView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class mapEvent extends Event 
	{
		public static const SET_MIN:String = "set_min";
		public static const GET_NODE_DETAIL:String = "get_node_detail";
		public static const FILTER:String = "filter";
		public static const RESET:String = "reset";
		public static const LIGHT:String = "light";
		public static const BALL_FILTER:String = "ball_filter";
		public static const SHOW_SETTINGS:String = "show_settings";
		
		private var _min:int;
		private var _ball:ballView;
		private var _is_reset_bl:Boolean = true;
		private var _is_show_bl:Boolean = false;
		private var _ball_name:String = '';
		
		public function mapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, min:int = 0) 
		{ 
			_min = min;
			super(type, bubbles, cancelable);
		}	
		
		/****************
		 * properties
		 * *************/
		public function set min(num:int):void {
			_min = num;
		}
		public function get min():int {
			return _min;
		}
		public function set ball(mc:ballView):void {
			_ball = mc;
		}
		public function get ball():ballView {
			return _ball;
		}
		public function set reset(bl:Boolean):void {
			_is_reset_bl = bl;
		}
		public function get reset():Boolean {
			return _is_reset_bl;
		}
		public function set show(bl:Boolean):void {
			_is_show_bl = bl;
		}
		public function get show():Boolean {
			return _is_show_bl;
		}
		public function set ballName(str:String):void {
			_ball_name = str;
		}
		public function get ballName():String {
			return _ball_name;
		}
		
		/*************
		 * methods
		 * ***********/
		public override function clone():Event { 
			var _evt:mapEvent = new mapEvent(type, bubbles, cancelable, _min);
			_evt.ball = _ball;
			_evt.ballName = _ball_name;
			_evt.reset = _evt.reset;
			return _evt;
		}
		public override function toString():String { 
			return formatToString("mapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}