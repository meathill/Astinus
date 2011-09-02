package brunch.clickHeatMap {
  import brunch.clickHeatMap.controller.GUI;
  import brunch.clickHeatMap.model.dataModel;
  import brunch.clickHeatMap.map.dataPanel;
  import brunch.clickHeatMap.map.mapView;
  import brunch.clickHeatMap.panel.controlPanelView;
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
   * 
   * 更新，重构，将新学的东西融进去
	 * @author	Meathill
	 * @version 0.2(2011-08-31)
	 */
	public class clickHeatMapMain extends basicMain	{
		//=========================================================================
    // Constructor
    //=========================================================================
		public function clickHeatMapMain() {
			super();
		}
		//=========================================================================
    // Variables
    //=========================================================================
		private var _data:dataModel;
		private var _loading_txt:TextField;
		private var _map:mapView;
		private var _loading:loadingView;
    //=========================================================================
    // Properties
    //=========================================================================
		public var helpButton:SimpleButton;
		public var optionsPanel:controlPanelView;
		/************
		 * functions
		 * *********/
		override protected function dataInit(evt:Event = null):void {
			_data = new dataModel();
			_data.parent = this;
			_data.clientWidth = dataPanel.cw = stage.stageWidth;
			_data.makeParam(loaderInfo.parameters);
			_data.addEventListener(ProgressEvent.PROGRESS, onDataLoading);
			_data.addEventListener(Event.COMPLETE, loadDataComplete);
			_data.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			_data.addEventListener(Event.CHANGE, onOffsetChange);
			_data.load();
      
      GUI.main = this;
			
			dataPanel.remote = dataModel.URL;
			dataPanel.search = _data.getParam().r;
			dataPanel.date = _data.getParam().d;
		}
		override protected function displayInit(evt:Event = null):void {
			_loading_txt = getChildAt(3) as TextField;
			_loading_txt.x = stage.stageWidth - _loading_txt.width >> 1;
			
			_loading = loadingView(getChildAt(2));
			_loading.x = stage.stageWidth - 50 >> 1;
			
			optionsPanel = getChildAt(0) as controlPanelView;
      optionsPanel.enabled = false;
      trace(stage.stageWidth, optionsPanel.width);
			optionsPanel.x = stage.stageWidth - optionsPanel.width;
			optionsPanel.addEventListener(Event.CHANGE, onStageResize);
			optionsPanel.addEventListener(Event.RESIZE, onLimitResize);
      optionsPanel.addEventListener(Event.CLOSE, GUI.switchButtonPanel);
			
			helpButton = removeChildAt(1) as SimpleButton;
			helpButton.x = stage.stageWidth - helpButton.width; 
			helpButton.addEventListener(MouseEvent.CLICK, GUI.switchButtonPanel);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		private function onLoadFailed(evt:IOErrorEvent):void {
			_loading_txt.text = '加载失败，请检查URL是否有效';
      removeChild(_loading);
      removeChild(optionsPanel);
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
			
			optionsPanel.max = _data.max;
			
			// 将地图宽度限制在1680以下，如此高度起码可以达到9600高
			_map = new mapView(stage.stageWidth > mapView.MAX_WIDTH ? mapView.MAX_WIDTH : stage.stageWidth, _data.pageHeight);
			_map.x = stage.stageWidth - _map.width >> 1;
			_map.data = _data;
			_map.addEventListener(Event.COMPLETE, onMapComplete);
			_map.draw(_data.top.concat(), _data.max, optionsPanel.limit);
			addChildAt(_map, 0);
		}
		private function onMapComplete(evt:Event):void {
			if (contains(_loading_txt)) {
				removeChild(_loading_txt);
			}
			_data.startWatchScroll();
      optionsPanel.enabled = true;
		}
		private function onLimitResize(evt:Event):void {
			_map.limit = optionsPanel.limit;
		}
		private function onOffsetChange(evt:Event):void {
			_map.y = -_data.offset + optionsPanel.toY;
		}
		private function onStageResize(evt:Event):void {			
			if (_map != null) {
				_map.x = (stage.stageWidth - _map.width >> 1) + optionsPanel.toX;
			}
      if (helpButton.visible) {
        helpButton.x = stage.stageWidth - helpButton.width;
      }
      if (optionsPanel.visible) {
        optionsPanel.x = stage.stageWidth - helpButton.width;
      }
		}
	}
}