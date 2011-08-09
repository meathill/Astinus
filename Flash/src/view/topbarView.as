package src.view 
{
	import com.bit101.components.Calendar;
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import lib.event.searchEvent;
	import src.event.mapEvent;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class topbarView extends Sprite
	{
		public static const _FILTER:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, .6);
		
		private const _default:Array = ['detail.zol.com.cn', 'mobile.zol.com.cn', 'nb.zol.com.cn', 'diy.zol.com.cn', 'dcdv.zol.com.cn'];
		private const _tip:String = '请在此输入您要查看的起始页面地址，支持正则';
		
		private var _search_txt:Text;
		private var _level_txt:InputText;
		private var _date_txt:InputText;
		private var _cache_cb:CheckBox;
		private var _calendar:Calendar;
		private var _history:List;
		private var _search_btn:PushButton;
		private var _menu_btn:PushButton;
		private var _reset_btn:PushButton;
		private var _search_option:Sprite;
		
		public function topbarView() 
		{
			init();
		}
		
		/****************
		 * properties
		 * *************/
		public function set isSearchable(bl:Boolean):void {
			_search_btn.enabled = bl;
		}
		public function set isResetable(bl:Boolean):void {
			_reset_btn.enabled = bl;
		}
		public function get level():String {
			return _level_txt.text;
		}
		public function get date():String {
			return _date_txt.text;
		}
		public function get isCached():Boolean {
			return _cache_cb.selected;
		}
		
		/****************
		 * functions
		 * *************/
		private function init():void {
			_search_btn = new PushButton(this, 505, 4, '搜索', searchHandler);
			_search_btn.setSize(40, 22);
			
			_menu_btn = new PushButton(this, 550, 4, '选项', showSettings);
			_menu_btn.setSize(40, 22);
			
			_reset_btn = new PushButton(this, 595, 4, '复原', resetHandler);
			_reset_btn.setSize(40, 22);
			_reset_btn.enabled = false;
			
			_search_txt = new Text(this, 100, 4, _tip);
			_search_txt.setSize(400, 22);
			_search_txt.textField.wordWrap = false;
			_search_txt.textField.multiline = false;
			_search_txt.addEventListener(FocusEvent.FOCUS_IN, showOptions);
			_search_txt.addEventListener(KeyboardEvent.KEY_DOWN, keyCheck);
			
			// 生成搜索选项面板
			_search_option = new Sprite();
			_search_option.graphics.beginFill(0xbbddff);
			_search_option.graphics.drawRoundRect(0, 0, 410, 135, 10, 10);
			_search_option.graphics.endFill();
			_search_option.x = 95;
			_search_option.y = -135;
			addChildAt(_search_option, 0);
			// 层级
			var _level_lbl:Label = new Label(_search_option, 5, 5, '层数：');
			_level_txt = new InputText(_search_option, 45, 5, '<5');
			_level_txt.restrict = '<>=0-9';
			_level_txt.setSize(60, 20);
			_level_txt.addEventListener(Event.CHANGE, levelCheck);
			_level_txt.addEventListener(KeyboardEvent.KEY_DOWN, keyCheck);
			// 日期
			var _yes:Date = new Date();
			_yes.date -= 1;
			var _date_lbl:Label = new Label(_search_option, 120, 5, '日期：');
			_date_txt = new InputText(_search_option, 160, 5, formatDate(_yes));
			_date_txt.setSize(60, 20);
			_date_txt.restrict = '[0-9]';
			_date_txt.addEventListener(FocusEvent.FOCUS_IN, showCalendar);
			// 缓存
			_cache_cb = new CheckBox(_search_option, 280, 8, '缓存');
			_cache_cb.selected = true;
			// 历史记录
			_history = new List(_search_option, 5, 30);
			_history.setSize(400, 100);
			_history.items = _default;
			_history.addEventListener(Event.SELECT, urlSeleted);
			// 日期选择
			Style.fontSize = 10;
			_calendar = new Calendar(_search_option, 160, 25);
			_calendar.visible = false;
			_calendar.addEventListener(Event.SELECT, setDate);
			
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			filters = [_FILTER];
		}
		private function addedHandler(evt:Event):void {
			resizeHandler();
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		private function resizeHandler(evt:Event = null):void { 
			getChildAt(1).width = stage.stageWidth;
		}
		private function keyCheck(evt:KeyboardEvent):void {
			if (evt.keyCode == 13 || evt.keyCode == 108) {
				searchHandler();
			}
		}
		private function searchHandler(evt:Event = null):void {
			hideOptions();
			
			_search_btn.enabled = false;
			_reset_btn.enabled = false;
			
			var _evt:searchEvent = new searchEvent(searchEvent.SEARCH);
			_evt.keyword = _search_txt.text;
			dispatchEvent(_evt);
		}
		private function levelCheck(evt:Event):void {
			if (int(_level_txt.text) > 10) {
				_level_txt.text = '10';
			}
		}
		private function showSettings(evt:MouseEvent = null):void {
			var _evt:mapEvent = new mapEvent(mapEvent.SHOW_SETTINGS);
			dispatchEvent(_evt);
		}
		private function showOptions(evt:Event = null):void {
			if (_search_txt.text == _tip) {
				_search_txt.text = '';
			} else {
				_search_txt.textField.setSelection(0, _search_txt.text.length - 1);
			}
			
			TweenLite.to(_search_option, .5, { y:25 } );
			// 检查是否要收起option
			stage.addEventListener(MouseEvent.CLICK, mouseClickCheck);
		}
		private function hideOptions(evt:Event = null):void {
			if (_search_txt.text == '') {
				_search_txt.text = _tip;
			}
			
			TweenLite.to(_search_option, .5, { y: -_search_option.height } );
		}
		private function urlSeleted(evt:Event):void {
			_search_txt.text = _history.selectedItem.toString();
		}
		private function mouseClickCheck(evt:MouseEvent):void {
			if (!_search_option.hitTestPoint(evt.stageX, evt.stageY) && !_search_txt.hitTestPoint(evt.stageX, evt.stageY)) {
				hideOptions();
			}
		}
		private function resetHandler(evt:MouseEvent):void {
			var _evt:mapEvent = new mapEvent(mapEvent.RESET);
			dispatchEvent(_evt);
		}
		private function showCalendar(evt:Event):void {
			_calendar.visible = true;
		}
		private function setDate(evt:Event = null, _date:Date = null):void {
			_calendar.visible = false;
			if (evt != null) _date = _calendar.selectedDate;
			_date_txt.text = formatDate(_date);
		}
		private function formatDate(obj:Date):String {
			var _result:String = obj.fullYear % 100 > 9 ? (obj.fullYear % 100).toString() : '0' + obj.fullYear % 100;
			_result += (obj.month + 1) > 9 ? obj.month + 1 : '0' + (obj.month + 1);
			_result += obj.date > 9 ? obj.date.toString() : '0' + obj.date;
			return _result;
		}
		
		/*************
		 * methods
		 * **********/
	}
}