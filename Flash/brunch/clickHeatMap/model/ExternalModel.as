package brunch.clickHeatMap.model {
  import flash.net.URLVariables;
	/**
   * 保存外部参数和外部命令调用
   * @author Meathill
   * @version 0.1(2011-09-05)
   */
  public class ExternalModel {
    //=========================================================================
    // Class Variables
    //=========================================================================
    private static var INSTANCE:ExternalModel;
    //=========================================================================
    // Class Public Methods
    //=========================================================================
    public static function getInstance(obj:Object = null):ExternalModel {
      if (INSTANCE == null) {
        INSTANCE = new ExternalModel(obj);
      }
      return INSTANCE;
    }
    //=========================================================================
    // Constructor
    //=========================================================================
    public function ExternalModel(obj:Object) {
      if (obj.hasOwnProperty('useHtmlDetail')) {
        _useHtmlDetail = obj.useHtmlDetail;
      }
      
      _param = new URLVariables();
      _param.r = 'http://dealer.zol.com.cn/';
			_param.d = '110624';
			_param.nocache = 0;
			_param.visitor = 'new';
			for (var prop:String in obj) {
        if (prop == 'd') {
          date = obj.d;
        }
        if (prop == 'r') {
          remote = obj.r;
        }
				_param[prop] = obj[prop];
			}
    }
    //=========================================================================
    // Properties
    //========================================================================= 
		public var clientWidth:int;
		public var date:String;
		public var search:String;
		public var remote:String;
    public function get useHtmlDetail():Boolean {
      return _useHtmlDetail;
    }
    public function get param():URLVariables {
      return _param;
    }
    //=========================================================================
    // Variables
    //=========================================================================
    private var _useHtmlDetail:Boolean = false;
    private var _param:URLVariables;
    //=========================================================================
    // Public Methods
    //=========================================================================
  }
}