package src.view.ui 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import src.event.adjustEvent;
	import src.view.element.lineView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class adjustWindowView extends Sprite
	{
		private var _num_txt:TextField;
		private var _submit_btn:SimpleButton;
		private var _adjust_line:lineView;
		
		private var _min_num:int = 0;
		
		public function adjustWindowView() 
		{
			_num_txt = TextField(getChildAt(1));
			_num_txt.restrict = '\\-0-9';
			_num_txt.addEventListener(Event.CHANGE, numCheck);
			_num_txt.addEventListener(KeyboardEvent.KEY_DOWN, keydownChecker);
			
			_submit_btn = SimpleButton(getChildAt(2));
			_submit_btn.addEventListener(MouseEvent.CLICK, submitHandler);
		}
		
		/**************
		 * properties
		 * ***********/
		public function set line(fo:lineView):void {
			_adjust_line = fo;
			if (fo) {
				_min_num = -fo.num;
			}
		}
		public function get line():lineView {
			return _adjust_line;
		}
		
		/**************
		 * functions
		 * ***********/
		private function addedHandler(evt:Event):void {
			stage.focus = this;
			stage.focus = _num_txt;
		}
		private function removedHandler(evt:Event):void {
			_num_txt.text = '';
		}
		private function keydownChecker(evt:KeyboardEvent):void {
			if (evt.keyCode == 13 || evt.keyCode == 108) {
				submitHandler();
			}
		}
		private function submitHandler(evt:MouseEvent = null):void {
			if (_num_txt.length) {
				var _evt:adjustEvent = new adjustEvent(adjustEvent.ADJUST);
				_evt.num = int(_num_txt.text);
				_evt.line = _adjust_line;
				dispatchEvent(_evt);
			}
		}
		private function numCheck(evt:Event):void {
			if (int(_num_txt.text) < _min_num) {
				_num_txt.text = _min_num.toString();
			}
		}
	}
}