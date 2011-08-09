package src.view.element 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class elementBasicView extends Sprite
	{
		public static var COLOR_GROUP:Object = {};
		
		protected static const _RADIUS:uint = 4;
		//protected static const _GLOW_FILTER:GlowFilter = new GlowFilter(0xff9999, .6, 4, 4);
		protected static const _TF:TextFormat = new TextFormat(null, 12, 0xffffff);
		
		protected static var _UNIT:int = 1000;
		protected static var _ITEMS_ARR:Vector.<elementBasicView>;
		protected static var _IS_FIXED_BL:Boolean = false;
		protected static var _IS_NUM_BL:Boolean = true;
		
		protected var _count:int = 0;
		protected var _label_txt:TextField;
		protected var _is_static_bl:Boolean = false;
		protected var _bg_shape:Shape;
		
		public function elementBasicView() 
		{
			init();
		}
		
		/***************
		 * properties
		 * ************/
		public function set num(num:int):void {
			_count = num;
		}
		public function get num():int {
			return _count;
		}
		
		/***************
		 * functions
		 * ************/
		protected function init():void {
			addEventListener(MouseEvent.ROLL_OVER, mouseOnHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			
			mouseChildren = false;
			_ITEMS_ARR[_ITEMS_ARR.length] = this;
			
			_bg_shape = new Shape();
			addChild(_bg_shape);
			
			_label_txt = new TextField();
			_label_txt.autoSize = TextFieldAutoSize.CENTER;
			_label_txt.defaultTextFormat = _TF;
			_label_txt.selectable = false;
		}
		protected function removedHandler(evt:Event):void {
			removeEventListener(MouseEvent.ROLL_OVER, mouseOnHandler);
			removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		/***************
		 * methods
		 * ************/
		public function mouseOnHandler(evt:MouseEvent = null, num:int = 0):void { 
			//alpha = 1;
			//filters = [_GLOW_FILTER];
		}
		public function mouseOutHandler(evt:MouseEvent = null, num:int = 0):void { 
			//alpha = .8;
			//filters = [];
		}
		public function draw():void {
			
		}
		public function showLable():void {
			_label_txt.x = -_label_txt.width * .5;
			_label_txt.y = -_label_txt.height * .5;
			addChild(_label_txt);
		}
		
		/*********************
		 * static properties
		 * ******************/
		public static function set UNIT(num:int):void {
			_UNIT = num;
		}
		public static function set isNum(bl:Boolean):void {
			_IS_NUM_BL = bl;
		}
		public static function get isNum():Boolean {
			return _IS_NUM_BL;
		}
		
		/*********************
		 * static methods
		 * ******************/
		public static function init():void {
			_ITEMS_ARR = new Vector.<elementBasicView>;
			_IS_FIXED_BL = false;
		}
		public static function itemsInit():void {
			for each (var _item:elementBasicView in _ITEMS_ARR) {
				_item.draw();
			}
		}
		public static function lightAllNodes(evt:Event = null):void { 
			_IS_FIXED_BL = !_IS_FIXED_BL;
			for each(var _item:elementBasicView in _ITEMS_ARR) {
				if (_item is ballView) {
					ballView(_item).status = _IS_FIXED_BL;
				}
			}
		}
		public static function colorInit():void {
			COLOR_GROUP['专区'] = 0xFF7A00;
			COLOR_GROUP['文章页'] = 0x0B90C8;
			COLOR_GROUP['产品库'] = 0x6983ac;
			COLOR_GROUP['博客'] = 0xfc6035;
			COLOR_GROUP['经销商'] = 0x985210;
			COLOR_GROUP['产品库'] = 0x6983ac;
			COLOR_GROUP['论坛'] = 0xC2D18E;
			COLOR_GROUP['论坛产品列表页'] = 0xC2D18E;
			COLOR_GROUP['论坛贴子页'] = 0xC2D18E;
			COLOR_GROUP['论坛系列列表页'] = 0xC2D18E;
			COLOR_GROUP['论坛子类列表页'] = 0xC2D18E;
			COLOR_GROUP['论坛'] = 0xC2D18E;
			COLOR_GROUP['论坛'] = 0xC2D18E;
			COLOR_GROUP['搜索'] = 0x34de55;
			COLOR_GROUP['问答堂'] = 0x25efab;
			COLOR_GROUP['其他频道首页'] = 0x899C28;
			COLOR_GROUP['产品综述页'] = 0x92A3AB;
			COLOR_GROUP['产品review页'] = 0x92A3AB;
			COLOR_GROUP['产品param页'] = 0x92A3AB;
			COLOR_GROUP['产品price页'] = 0x92A3AB;
			COLOR_GROUP['产品sample页'] = 0x92A3AB;
			COLOR_GROUP['产品video页'] = 0x92A3AB;
			COLOR_GROUP['产品pic页'] = 0x92A3AB;
			COLOR_GROUP['产品图片页(index)'] = 0x92A3AB;
			COLOR_GROUP['其他频道'] = 0x006E2E
			COLOR_GROUP['出站口'] = 0xA6EEFC;
			COLOR_GROUP['产品列表页'] = 0xFECD33;
			COLOR_GROUP['首页'] = 0xFC83D0;
			COLOR_GROUP['产品图片最终页'] = 0xE20806;
			COLOR_GROUP['产品参数报价等页'] = 0x772100;
			COLOR_GROUP['专区页'] = 0x00ff00;
			COLOR_GROUP['专题页'] = 0xff0000;
			COLOR_GROUP['NULL'] = 0x666666;
			COLOR_GROUP['跳出'] = 0x000000;
		}
	}
}