var feClickHeat = {
  initClick : function () {
    var _array = ['a', 'area'];
    for (var n = 0; n < _array.length; n++) {
      var _arr = document.getElementsByTagName(_array[n]);
      if (document.addEventListener) {
        for (var i = 0, len = _arr.length; i < len; i++) {
          _arr[i].addEventListener("mousedown", this.clickInfo, false);
        }
      } else if (document.attachEvent) {
        for (var i = 0, len = _arr.length; i < len; i++) {
          _arr[i].attachEvent("onmousedown", this.clickInfo);
        }
      }
    }
  },

  clickInfo : function (l) {
    var clickLeft = 0, _res = '';
    var target = l.srcElement || l.target;
    if (target.tagName.toLowerCase() == 'img'){
  target = target.parentNode;
    }

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
    writeck(_final_url, _res, 0.1);

    var _target_url = target.href;
    if(typeof(_target_url)=='undefined'){
        return;
    }
    if(_target_url.indexOf("zol.com")==-1 && _target_url.indexOf("fengniao.com")==-1 && _target_url.indexOf("xiyuit.com")==-1 && _target_url.indexOf("cnmo.com")==-1 && _target_url.indexOf("xgo.com.cn")==-1 && _target_url.indexOf("pchome.net")==-1 && _target_url.indexOf("xiaoshuoku.com.cn")==-1 && _target_url.indexOf("wolun.com.cn")==-1 && _target_url.indexOf("ea3w.com")==-1 && _target_url.indexOf("2u.com.cn")==-1 && _target_url.indexOf("zdnet.com.tw")==-1 && _target_url.indexOf("3qit.com")==-1 && _target_url.indexOf("-img.com.cn")==-1 && _target_url.indexOf("-img.com")==-1 && _target_url.indexOf("55bbs.com")==-1 && _target_url.indexOf("http://")==0) {
  var _text = target.innerText;
  var now = new Date().getTime();
  var datestr=escape(now*1000+Math.round(Math.random()*1000));
  var _imgsrc_exit = 'http://linkout.zol.com.cn/images/pvhit0011.gif?t='+ datestr + '&'+ _target_url +'&ip_ck='+ ip_ck +'&lv='+ lv +'&vn='+ vn +'&sr='+ sr +'&sc='+ sc +'&fl='+ flash +'&ti='+ _text +'&uv='+ uv +'&cv='+ _res;
  document.getElementById('dot_pvm').src = _imgsrc_exit;
    }

  },

  getPosition : function (ele) {
    var x = ele.offsetLeft + (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderLeftWidth)) : 0);
    var y = ele.offsetTop + (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderTopWidth)) : 0);

    while (ele.offsetParent) {
      ele = ele.offsetParent;
      x += ele.offsetLeft + (ele.currentStyle ? feClickHeat.isInt(parseInt(ele.currentStyle.borderLeftWidth)) : 0);
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