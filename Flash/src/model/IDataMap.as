package src.model 
{
	import flash.display.DisplayObject;
	import src.view.element.ballView;
	import src.view.element.lineView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public interface IDataMap 
	{
		function addItem(content:String, index:int, num:int = 0, bl:Boolean = false):ballView;
		function addLine(from:ballView, to:ballView, num:int = 0):void;
		function getItemByIndex(caption:String, x:int):DisplayObject;
	}
	
}