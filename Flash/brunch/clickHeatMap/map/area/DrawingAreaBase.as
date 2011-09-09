package brunch.clickHeatMap.map.area {
  import brunch.clickHeatMap.model.ExternalModel;
  import effects.DisplayUtils;
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
	
	/**
	 * 绘制区域示意图
	 * @author	Meathill
	 * @version	0.1(2011-02-24)
	 */
	public class DrawingAreaBase extends Sprite	{
    //=========================================================================
    // Class Constants
    //=========================================================================
		public static const PANEL_WIDTH:int = 450;
		public static const PANEL_HEIGHT:int = 300;
		//=========================================================================
    // Class Variables
    //=========================================================================
		public static var cur:DrawingArea;
    public static var count:int = -1;
    public static var items:Array = [];
		//=========================================================================
    // Class Public Methods
    //=========================================================================
    public static function setEnabled(bl:Boolean):void {
      for each (var item:DrawingArea in items) {
        item.enabled = bl;
      }
    }
		//=========================================================================
    // Constructor
    //=========================================================================
		public function DrawingAreaBase() {
			init();
		}
		protected function init():void {
			enabled = false;
      items.push(this);
      index = count++;
			
			closeButton = removeChildAt(0) as SimpleButton;
			closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
			
			hideButton = removeChildAt(0) as SimpleButton;
			hideButton.addEventListener(MouseEvent.CLICK, toggleList);
			
			_num_txt = removeChildAt(0) as TextField;
			_num_txt.mouseEnabled = false;
			_num_txt.autoSize = TextFieldAutoSize.CENTER;
			
			addEventListener(MouseEvent.MOUSE_DOWN, stopPropagation);
		}
    //=========================================================================
    // Variables
    //=========================================================================
		private var _width:int = 10;
		private var _height:int = 10;
		private var _num_txt:TextField;
		private var _panel:DataPanel;
		protected var closeButton:SimpleButton;
		protected var hideButton:SimpleButton;
    protected var index:int = 0;
    protected var external:ExternalModel;
    //=========================================================================
    // properties
    //=========================================================================
    public var color:uint = 0x336699;
		public function set isCur(bl:Boolean):void {
			if (bl) {
				if (cur != null && cur != this) {
          if (parent != null && parent.contains(cur)) { 
            parent.setChildIndex(this, parent.getChildIndex(cur));
          }
				}
				cur = this;
			}
		}
		public function get isCur():Boolean {
			return cur == this;
		}
		public function set fixed(bl:Boolean):void {
			if (bl) {
				closeButton.x = _width - 20;
				addChild(closeButton);
			} else {
				removeChild(closeButton);
			}
			enabled = bl;
		}
		public function set detail(arr:Vector.<Array>):void {
      external = ExternalModel.getInstance();
      if (external.useHtmlDetail) {
        external.showDetail(arr, getRect(parent), color, index);
      } else {
        if (null == _panel) {
          _panel = new dataPanel(this, _width + 16);
          _panel.setSize(PANEL_WIDTH, _height > PANEL_HEIGHT ? _height : PANEL_HEIGHT);
          _panel.pos = [x, y, _width, _height];
        }
        var _list_arr:Array = [];
        for (var i:int = 0, len:int = arr.length; i < len; i += 1) {
          _list_arr[i] = arr[i][4] + ' | ' + arr[i][5];
        }
        _panel.url = _list_arr;
        
        // 隐藏按钮
        hideButton.x = _width + 4, hideButton.y = _height - hideButton.height >> 1;
        addChild(hideButton);
        
        // 基于当前坐标的特殊处理
        if (stage.stageWidth - x - _width < PANEL_WIDTH + 16) {
          _panel.x = - PANEL_WIDTH - 16;
          hideButton.x = -4;
          hideButton.scaleX = -hideButton.scaleX;
          if (x < PANEL_WIDTH + 16) {
            hideButton.x = 4, hideButton.scaleX = 1;
            _panel.x = 16, _panel.y = 12;
            _panel.setSize(PANEL_WIDTH, _height > PANEL_HEIGHT ? _height : PANEL_HEIGHT);
          }
        }
      }
		}
		override public function get width():Number {
			return _width;
		}
		override public function get height():Number {
			return _height;
		}
    public function set enabled(bl:Boolean):void {
      mouseChildren = mouseEnabled = bl;
    }
		//=========================================================================
    // Protected Functions
    //=========================================================================
		protected function closeHandler(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
      DisplayUtils.COLORS.push(color);
      items.splice(items.indexOf(this), 1);
			parent.removeChild(this);
      
      external = null;
		}
		protected function stopPropagation(evt:MouseEvent):void {
			evt.stopPropagation();
		}
		protected function toggleList(evt:MouseEvent):void {
			hideButton.x += 8 * hideButton.scaleX;
			hideButton.scaleX = -hideButton.scaleX;
			_panel.visible = !_panel.visible;
		}
		//=========================================================================
    // Public Methods
    //=========================================================================
		public function setSize(w:int = 0, h:int = 0):void {
			// 下面这俩货是取绝对值的哟
			if (w != 0)	_width = (w ^ (w >> 31)) - (w >> 31);
			if (h != 0) _height = (h ^ (h >> 31)) - (h >> 31);
			graphics.clear();
      graphics.lineStyle(4, 0xffffff, .75);
      graphics.beginFill(color, .5);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		public function setNum(num:int, per:Number):void {
			_num_txt.text = num + '(' + int(per * 10000) / 100 + '%)';
			_num_txt.x = _width - _num_txt.width >> 1;
			_num_txt.y = _height - _num_txt.height >> 1;
			addChild(_num_txt);
		}
    public function remove():void {
      closeHandler();
    }
	}
}