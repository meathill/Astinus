var feClickHeat = {

	initClickA : function () {
    var _arr = document.getElementsByTagName('a');
		if (document.addEventListener) {
      for (var i = 0, len = _arr.length; i < len; i++) {
        _arr[i].addEventListener("mousedown", this.clickInfo, false);
      }
		} else if (document.attachEvent) {
      for (var i = 0, len = _arr.length; i < len; i++) {
        _arr[i].attachEvent("onmousedown", this.clickInfo);
      }
		}
	},

	clickInfo : function (l) {
		var clickLeft = 0, _res = '';
		var target = l.srcElement || l.target;

		var _final_url = document.location.href;
		var _flag = _final_url.indexOf("?");
		if (_flag != -1) {
			_final_url = _final_url.substr(0, _flag);
		}
		var _cw = document.documentElement.clientWidth;
		var _ch = document.documentElement.clientHeight;
		var _st = document.documentElement.scrollTop;
		if(_st == 0){
			_st = document.body.scrollTop;
		}
		_obj = feClickHeat.getPosition(target);
		_res = feClickHeat.makeOutput([_obj.x, _obj.y, target.offsetWidth, target.offsetHeight, _cw, _ch, _st]);
    // w = width, h = height, cw = clientWidth, ch = clientHeight, st = scrollTop
    //alert(target.href.toString());
    alert(target.href);
    return false;
	},

	getPosition : function (ele) {

		var x = ele.offsetLeft + (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderLeftWidth)) : 0);
		var y = ele.offsetTop	+ (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderTopWidth)) : 0);

		while (ele.offsetParent) {
			ele = ele.offsetParent;
			x += ele.offsetLeft	+ (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderLeftWidth)) : 0);
			y += ele.offsetTop + (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderTopWidth)) : 0);
		}
		return {x : x, y : y};
	},

	isInt : function (num) {
		return isNaN(num) ? 0 : num;
	},
  
  numFormat : function (num) {
    var _result = num.toString(16);
    _result = _result.slice(0, -1) + (parseInt(_result.slice(-1), 16) + 0x10).toString(36);
    return _result;
  },
  
  makeOutput : function (arr) {
    var _result = '';
    for (var i = 0, len = arr.length; i < len; i++) {
      _result += feClickHeat.numFormat(arr[i]);
    }
    return _result;
  }
  
}

feClickHeat.initClickA();
