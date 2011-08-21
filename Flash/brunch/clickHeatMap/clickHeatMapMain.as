package brunch.clickHeatMap 
{
	import brunch.clickHeatMap.model.dataModel;
	import brunch.clickHeatMap.view.controlPanelView;
	import brunch.clickHeatMap.view.dataPanel;
	import brunch.clickHeatMap.view.mapView;
	import com.greensock.TweenLite;
	import com.zol.basicMain;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import lib.component.loadingView;
	import lib.meatClass.utils.meatMath;
	
	/**
	 * 点击热图生成工具
	 * 是用户访问路径的一个子集
	 * 所以建了一个所谓的brunch包
	 * 现在接近凌晨1点，脑子不是很清楚，先这么着吧
	 * @author	Meathill
	 * @version 0.1(2011-02-18)
	 */
	public class clickHeatMapMain extends basicMain
	{
		private var _data:dataModel;
		private var _loading_txt:TextField;
		private var _help_btn:SimpleButton;
		private var _help_mc:controlPanelView;
		private var _map:mapView;
		private var _loading:loadingView;
		
		public function clickHeatMapMain() 
		{
			super();
		}
		
		/************
		 * functions
		 * *********/
		override protected function dataInit(evt:Event = null):void {
			_menu.version = '0.3';
			
			_data = new dataModel();
			_data.parent = this;
			_data.clientWidth = dataPanel.cw = stage.stageWidth;
			_data.makeParam(loaderInfo.parameters);
			_data.addEventListener(ProgressEvent.PROGRESS, onDataLoading);
			_data.addEventListener(Event.COMPLETE, loadDataComplete);
			_data.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			_data.addEventListener(Event.CHANGE, onOffsetChange);
			_data.load();
			
			dataPanel.remote = dataModel.URL;
			dataPanel.search = _data.getParam().r;
			dataPanel.date = _data.getParam().d;
		}
		override protected function displayInit(evt:Event = null):void {
			_loading_txt = getChildAt(3) as TextField;
			_loading_txt.x = stage.stageWidth - _loading_txt.width >> 1;
			
			_loading = loadingView(getChildAt(2));
			_loading.x = stage.stageWidth - 50 >> 1;
			
			_help_mc = getChildAt(1) as controlPanelView;
			_help_mc.x = stage.stageWidth - 260;
			_help_mc.toggleHelp();
			_help_mc.addEventListener(Event.CHANGE, onStageResize);
			_help_mc.addEventListener(Event.RESIZE, onLimitResize);
			
			_help_btn = getChildAt(0) as SimpleButton;
			_help_btn.x = stage.stageWidth - 40; 
			_help_btn.addEventListener(MouseEvent.CLICK, _help_mc.toggleHelp);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		private function onLoadFailed(evt:IOErrorEvent):void {
			_loading_txt.text = '加载失败，请检查URL是否有效';
		}
		private function onDataLoading(evt:ProgressEvent):void {
			if (evt.bytesTotal != 0) {
				_loading_txt.text = '已加载：' + int(evt.bytesLoaded / evt.bytesTotal * 10000) / 100 + '%';
			} else {
				_loading_txt.text = '已加载：' + meatMath.formatBytes(evt.bytesLoaded);
			}
		}
		private function onDataParsing(evt:ProgressEvent):void {
			_loading_txt.text = '已分析：' + int(evt.bytesLoaded / evt.bytesTotal * 10000) / 100 + '%';
		}
		private function loadDataComplete(evt:Event):void {
			removeChild(_loading);
			
			_loading_txt.text = '开始分析数据，请稍候~~';
			_data.removeEventListener(Event.COMPLETE, loadDataComplete);
			_data.removeEventListener(ProgressEvent.PROGRESS, onDataLoading);
			_data.addEventListener(Event.COMPLETE, startDrawMap);
			_data.addEventListener(ProgressEvent.PROGRESS, onDataParsing);
		}
		private function startDrawMap(evt:Event):void {
			_loading_txt.text = '分析完毕，绘图中';
			_data.removeEventListener(Event.COMPLETE, startDrawMap);
			_data.removeEventListener(ProgressEvent.PROGRESS, onDataParsing);
			
			_help_mc.max = _data.max;
			
			// 将地图宽度限制在1680以下，如此高度起码可以达到9600高
			_map = new mapView(stage.stageWidth > mapView.MAX_WIDTH ? mapView.MAX_WIDTH : stage.stageWidth, _data.pageHeight);
			_map.x = stage.stageWidth - _map.width >> 1;
			_map.data = _data;
			_map.addEventListener(Event.COMPLETE, onMapComplete);
			_map.draw(_data.top.concat(), _data.max);
			addChildAt(_map, 0);
		}
		private function onMapComplete(evt:Event):void {
			if (contains(_loading_txt)) {
				removeChild(_loading_txt);
			}
			_data.startWatchScroll();
		}
		private function onLimitResize(evt:Event):void {
			_map.limit = _help_mc.limit;
		}
		private function onOffsetChange(evt:Event):void {
			_map.y = -_data.offset + _help_mc.toY;
		}
		private function onStageResize(evt:Event):void {			
			if (_map != null) {
				_map.x = (stage.stageWidth - _map.width >> 1) + _help_mc.toX;
			}
		}
	}
}