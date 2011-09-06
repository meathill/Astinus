package brunch.clickHeatMap {
  import brunch.clickHeatMap.controller.GUI;
  import brunch.clickHeatMap.map.MapView;
  import brunch.clickHeatMap.model.DataModel;
  import brunch.clickHeatMap.map.dataPanel;
  import brunch.clickHeatMap.model.ExternalModel;
  import brunch.clickHeatMap.panel.ControlPanelView;
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
	public class ClickHeatMapMain extends basicMain	{
		//=========================================================================
    // Constructor
    //=========================================================================
		public function ClickHeatMapMain() {
			super();
		}
		//=========================================================================
    // Variables
    //=========================================================================
		private var data:DataModel;
    private var external:ExternalModel;
		private var _loading_txt:TextField;
		private var _map:MapView;
		private var _loading:loadingView;
    //=========================================================================
    // Properties
    //=========================================================================
		public var helpButton:SimpleButton;
		public var optionsPanel:ControlPanelView;
		/************
		 * functions
		 * *********/
		override protected function dataInit(evt:Event = null):void {
      external = ExternalModel.getInstance(loaderInfo.parameters);
			external.remote = DataModel.URL;
      
			data = new DataModel();
			data.parent = this;
      data.param = external.param;
			data.clientWidth = external.clientWidth = stage.stageWidth;
			data.addEventListener(ProgressEvent.PROGRESS, onDataLoading);
			data.addEventListener(Event.COMPLETE, loadDataComplete);
			data.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			data.addEventListener(Event.CHANGE, onOffsetChange);
			data.load();
      
      GUI.main = this;
		}
		override protected function displayInit(evt:Event = null):void {
			_loading_txt = getChildAt(3) as TextField;
			_loading_txt.x = stage.stageWidth - _loading_txt.width >> 1;
			
			_loading = loadingView(getChildAt(2));
			_loading.x = stage.stageWidth - 50 >> 1;
			
			optionsPanel = getChildAt(0) as ControlPanelView;
      optionsPanel.enabled = false;
			optionsPanel.x = stage.stageWidth - ControlPanelView.WIDTH;
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
			data.removeEventListener(Event.COMPLETE, loadDataComplete);
			data.removeEventListener(ProgressEvent.PROGRESS, onDataLoading);
			data.addEventListener(Event.COMPLETE, startDrawMap);
			data.addEventListener(ProgressEvent.PROGRESS, onDataParsing);
		}
		private function startDrawMap(evt:Event):void {
			_loading_txt.text = '分析完毕，绘图中';
			data.removeEventListener(Event.COMPLETE, startDrawMap);
			data.removeEventListener(ProgressEvent.PROGRESS, onDataParsing);
			
			optionsPanel.max = data.max;
			
			// 将地图宽度限制在1680以下，如此高度起码可以达到9600高
			_map = new MapView(stage.stageWidth > MapView.MAX_WIDTH ? MapView.MAX_WIDTH : stage.stageWidth, data.pageHeight);
			_map.x = stage.stageWidth - _map.width >> 1;
			_map.data = data;
			_map.addEventListener(Event.COMPLETE, onMapComplete);
			_map.draw(data.top.concat(), data.max, optionsPanel.limit);
			addChildAt(_map, 0);
		}
		private function onMapComplete(evt:Event):void {
			if (contains(_loading_txt)) {
				removeChild(_loading_txt);
			}
			data.startWatchScroll();
      optionsPanel.enabled = true;
		}
		private function onLimitResize(evt:Event):void {
			_map.limit = optionsPanel.limit;
		}
		private function onOffsetChange(evt:Event):void {
			_map.y = -data.offset + optionsPanel.toY;
		}
		private function onStageResize(evt:Event):void {			
			if (_map != null) {
				_map.x = (stage.stageWidth - _map.width >> 1) + optionsPanel.toX;
			}
      if (helpButton.visible) {
        helpButton.x = stage.stageWidth - helpButton.width;
      }
      if (optionsPanel.visible) {
        optionsPanel.x = stage.stageWidth - ControlPanelView.WIDTH;
      }
		}
	}
}