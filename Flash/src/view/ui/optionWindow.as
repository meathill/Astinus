package src.view.ui 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HUISlider;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lib.component.grid.gridBasicView;
	import src.event.mapEvent;
	/**
	 * 选项窗体
	 * @author Meathill
	 */
	public class optionWindow extends commonWindowView
	{
		private var _slider:HUISlider;
		private var _light:CheckBox;
		private var _grid:gridBasicView;
		
		public function optionWindow() 
		{
			super();
			
			init();
		}
		
		/***************
		 * properties
		 * ************/
		public function set min(num:int):void {
			_slider.minimum = num > 1 ? num : 1;
		}
		public function set max(num:int):void {
			_slider.maximum = num;
		}
		public function get isLight():Boolean {
			return _light.selected;
		}
		public function set isSetable(bl:Boolean):void {
			_slider.enabled = bl;
		}
		
		/***************
		 * functions
		 * ************/
		private function init():void {
			_title_txt.text = '选项';
			
			_light = new CheckBox(this, 7, 24, '显示节点比例', lightHandler);
			_light.selected = true;
			
			_slider = new HUISlider(this, 5, 42, '节点最小值', setMinValue);
			_slider.enabled = false;
			_slider.tick = 1;
			_slider.minimum = 1;
			
			_grid = new gridBasicView(this, 5, 65);
			_grid.setSize(210, 220);
			_grid.col = 2;
			_grid.itemWidth = 90;
			_grid.itemHeight = 16;
			_grid.space = 10;
			_grid.autoHideScrollBar = true;
			
			_title_bar.height = 300;
		}
		private function lightHandler(evt:Event):void {
			var _evt:mapEvent = new mapEvent(mapEvent.LIGHT);
			dispatchEvent(_evt);
		}
		private function setMinValue(evt:Event):void {
			var _evt:mapEvent = new mapEvent(mapEvent.SET_MIN);
			_evt.min = _slider.value;
			dispatchEvent(_evt);
		}
		private function setNodeVisible(evt:MouseEvent):void {
			var _evt:mapEvent = new mapEvent(mapEvent.BALL_FILTER);
			_evt.ballName = CheckBox(evt.target).label;
			_evt.show = CheckBox(evt.target).selected;
			dispatchEvent(_evt);
		}
		
		/***************
		 * methods
		 * ************/
		public function showNodeNames(arr:Vector.<String>):void {
			for (var i:int = 0, len:int = _grid.length; i < len; i += 1) {
				_grid.getItemAt(i).removeEventListener(MouseEvent.CLICK, setNodeVisible);
			}
			_grid.removeAll();
			for each (var _name:String in arr) {
				var _cb:CheckBox = new CheckBox();
				_cb.label = _name;
				_cb.selected = true;
				_cb.addEventListener(MouseEvent.CLICK, setNodeVisible);
				_grid.addItem(_cb);
			}
		}
		public function selectedAll():void {
			for (var i:int = 0, len:int = _grid.length; i < len; i += 1) {
				CheckBox(_grid.getItemAt(i)).selected = true;
			}
		}
	}
}