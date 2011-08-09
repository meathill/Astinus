package src 
{
	import com.bit101.components.Style;
	import com.zol.basicMain;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import lib.event.searchEvent;
	import lib.component.tips.tipsBasicView;
	import lib.meatClass.utils.meatMath;
	import src.event.mapEvent;
	import src.model.dataModel;
	import src.view.columnView;
	import src.view.mapView;
	import src.view.topbarView;
	import src.view.element.ballView;
	import src.view.element.elementBasicView;
	import src.view.element.lineView;
	import src.view.ui.infoMsgView;
	import src.view.ui.nodeDetailWindow;
	import src.view.ui.optionWindow;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class userRootMapMain extends basicMain
	{
		private var _data:dataModel;
		private var _topbar:topbarView;
		private var _info:infoMsgView;
		private var _map:mapView;
		private var _option:optionWindow;
		private var _detail:nodeDetailWindow;
		private var _is_num_bl:Boolean = false;
		private var _is_line_adjustable_bl:Boolean = false;
		
		public function userRootMapMain() 
		{
			super();
		}
		
		/****************
		 * functions
		 * *************/
		override protected function init(evt:Event = null):void {
			super.init(evt);
			
			_menu.version = '0.2';
		}
		override protected function dataInit(evt:Event = null):void {
			_data = new dataModel();
			_data.tar = this;
			_data.addEventListener(ProgressEvent.PROGRESS, dataLoadProgressHandler);
			_data.addEventListener(IOErrorEvent.IO_ERROR, onNoData);
			_data.addEventListener(Event.COMPLETE, drawMap);
			
			if (loaderInfo.parameters.hasOwnProperty('show_num') && loaderInfo.parameters.show_num == '1') { 
				_is_num_bl = true;
			}
			if (loaderInfo.parameters.hasOwnProperty('adjustable') && loaderInfo.parameters.adjustable == '1') {
				_is_line_adjustable_bl = true;
			}
			//_data.addEventListener(ProgressEvent.PROGRESS, dataLoadProgressHandler);
			//_data.loadStaticDate();
		}
		override protected function displayInit(evt:Event = null):void {			
			//提示信息
			tipsBasicView.init(stage);
			Style.fontSize = 12;
			Style.LABEL_TEXT = 0x333333;
			
			_topbar = topbarView(getChildAt(0));
			_topbar.addEventListener(searchEvent.SEARCH, searchHandler);
			_topbar.addEventListener(mapEvent.RESET, resetHandler);
			_topbar.addEventListener(mapEvent.SHOW_SETTINGS, showSettings);
			
			_info = infoMsgView(getChildAt(1));
			_info.text = '请选择您要查看的频道';
			
			_map = new mapView();
			_map.y = 30;
			_map.addEventListener(mapEvent.GET_NODE_DETAIL, getDetailHandler);
			_map.addEventListener(mapEvent.FILTER, filterDataHandler);
			_map.addEventListener(mapEvent.BALL_FILTER, filterNodeHandler);
			addChildAt(_map, 0);
			
			_option = new optionWindow();
			_option.x = (stage.stageWidth - _option.width) * .5;
			_option.y = (stage.stageHeight - _option.height) * .5;
			_option.addEventListener(mapEvent.LIGHT, elementBasicView.lightAllNodes);
			_option.addEventListener(mapEvent.SET_MIN, setMinHandler);
			_option.addEventListener(mapEvent.BALL_FILTER, filterNodeHandler);
			_option.addEventListener(Event.CLOSE, childCloseHandler);
			
			elementBasicView.colorInit();
			elementBasicView.isNum = _is_num_bl;
			ballView.nodeMenuInit();
			ballView.MAP = _map;
			lineView.lineMenuInit();
			lineView.isAdjustable = _is_line_adjustable_bl;
			// 看下负载情况
			/*var _debug:resouceMonitorView = new resouceMonitorView();
			addChild(_debug);*/
		}
		private function onNoData(evt:IOErrorEvent):void {
			_info.text = '服务器没找到数据，检查下输入内容，再试一次吧';
			_topbar.isSearchable = true;
		}
		private function loadCompleteDelay(evt:Event):void {
			// 延迟一帧的时间，以便显示文字
			_info.text = '开始绘图了，耐心等待下~~';
			addEventListener(Event.ENTER_FRAME, drawMap);
		}
		private function drawMap(evt:Event = null, draw_data:Array = null):void { 
			removeEventListener(Event.ENTER_FRAME, drawMap);
			
			if (draw_data == null) {
				draw_data = _data.data;
			}
			
			_map.isLight = _option.isLight;
			_map.length = _data.maxCol;
			_map.drawMap(draw_data);
			
			_info.text = '绘图完毕，哦也（共绘制' + draw_data.length + '条数据）';
			_topbar.isSearchable = true;
			_topbar.isResetable = true;
			_option.min = _map.min;
			_option.isSetable = true;
			_option.showNodeNames(_map.nodeNameList);
		}
		private function dataLoadProgressHandler(evt:ProgressEvent):void {
			if (evt.bytesTotal == 0) {
				_info.text = "加载数据中，请稍后（ 已加载 " + meatMath.formatBytes(evt.bytesLoaded) + "）";
			} else {
				_info.text = "加载数据中，请稍后（ " + int(evt.bytesLoaded / evt.bytesTotal * 100).toString() + "% ）";
			}
		}
		private function dataError(evt:IOErrorEvent):void {
			_info.text = '数据加载出错，请检查';
		}
		private function searchHandler(evt:searchEvent):void {
			trace("search : " + evt.keyword);
			elementBasicView.COLOR_GROUP[evt.keyword] = 0x5EC4EA;
			elementBasicView.COLOR_GROUP[evt.keyword+' 首页'] = 0xBB499E;
			_info.text = '服务器检索数据中，请稍后';
			_data.loadRemoteData(evt.keyword, _topbar.date, _topbar.level, _topbar.isCached ? '' : '1');
		}
		private function getDetailHandler(evt:mapEvent):void {
			if (_detail == null) {
				_detail = new nodeDetailWindow();
				_detail.isNum = _is_num_bl;
				_detail.addEventListener(Event.CLOSE, childCloseHandler);
			}
			var _pos:Point = new Point(0, 0);
			_pos = evt.ball.localToGlobal(_pos);
			_detail.x = _pos.x;
			_detail.y = _pos.y;
			_detail.total = evt.ball.num;
			_detail.url = evt.ball.name;
			_detail.index = int(evt.ball.parent.name.slice(1));
			_detail.showTable(_data.getNodeDataByName(evt.ball.name));
			addChild(_detail);
		}
		private function resetHandler(evt:mapEvent):void {
			if (_data.isFiltered) {
				// 舞台上并非全部数据
				drawMap();
			} else {
				// 舞台上已经是全部数据
				_map.showAll();
			}
			_option.selectedAll();
		}
		private function filterDataHandler(evt:mapEvent):void {
			_data.isFiltered = true;
			var _name:String = evt.ball.name;
			var _index:int = int(evt.ball.parent.name.slice(1));
			drawMap(null, _data.filterData(_name, _index, evt.reset));
		}
		private function filterNodeHandler(evt:mapEvent):void {
			trace(evt.ballName, evt.show);
			columnView.filterNodeByName(evt.ballName, evt.show);
		}
		private function showSettings(evt:mapEvent):void {
			addChild(_option);
		}
		private function setMinHandler(evt:mapEvent):void {
			columnView.filterNodeLess(evt.min);
		}
		private function childCloseHandler(evt:Event):void {
			if (contains(Sprite(evt.target))) {
				removeChild(Sprite(evt.target));
			}
		}
	}
}