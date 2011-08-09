package brunch.clickHeatMap.view 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 当前链接提示窗
	 * @author	Meathill
	 * @version	0.1(2011-06-14)
	 */
	public class curLinkTips extends Sprite
	{
		private const _GLOW:GlowFilter = new GlowFilter(0xff0000, .6, 8, 8);
		private var _bg:DisplayObject;
		private var _url_txt:TextField;
		private var _txt_bg:DisplayObject;
		
		
		public function curLinkTips() 
		{
			init();
		}
		
		/************
		 * functions
		 * *********/
		private function init():void {
			mouseChildren = mouseEnabled = false;
			
			_bg = getChildAt(0);
			_bg.filters = [_GLOW];
			
			_txt_bg = getChildAt(1);
			
			_url_txt = getChildAt(2) as TextField;
			_url_txt.multiline = true;
			_url_txt.autoSize = TextFieldAutoSize.LEFT;
			
			var _menu_item:ContextMenuItem = new ContextMenuItem('打开此页面');
			var _menu:ContextMenu = new ContextMenu();
			_menu.hideBuiltInItems();
			_menu.customItems.push(_menu_item);
			contextMenu = _menu;
		}
		
		/************
		 * methods
		 * *********/
		public function setContent(url:String, num:int, w:int, h:int):void {
			_bg.width = w, _bg.height = h;
			_url_txt.text = url + '\n=> ' + num;
			_txt_bg.width = _url_txt.width, _txt_bg.height = _url_txt.height;
		}
	}
}