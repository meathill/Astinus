/*
	markHeat:	��λ���λ��
*/
var markHeat = {
  width : 1120,
  url : '',
  // �����ҳ�棬����̳Ϊ����ֻ��ͨ���������ж�
  rep : /\/product\.|bbs\.|\/idea|\/se\.|\/nokia\.|\/moto\.|\/samsung\.|\/lenovo\./,
  showArea : function (pos_str, h) {
    var _arr = pos_str.split('#');
    if (_arr[0] != this.url) {
      this.url = _arr[0];
      $('#myiframe').attr('src', '/cgi-bin/zdt/page_filter.cgi?page=' + this.url);
    }
    elmPos = markHeat.getPositionString(_arr[1]);
    $('#myiframe').height(elmPos[1] + h);
    $('#con').css('top', '-' + (elmPos[1] > h >> 1 ? elmPos[1] - (h >> 1) : 0) + 'px');
    $('#con div').remove('.mark');
    $('#con').append(markHeat.createMark(elmPos[0], elmPos[1], elmPos[2], elmPos[3], _arr[3]));
  },
  createMark : function(x, y, w, h, alt){
		o = $("<div>", {'class':'mark', 'title':alt});
		o.css('left', x + "px");
		o.css('top', y+ "px");
		o.width(w);
		o.height(h);
		return o;
  },
  getPositionString : function(url){
    var _result = [], _rec = '';
    for (var i = 0, len = url.length; i < len; i++) {
      if (url.charCodeAt(i) > 102) {
        _result.push(parseInt(_rec + (parseInt(url.charAt(i), 36) - 16).toString(16), 16));
        _rec = '';
      } else {
        _rec += url.charAt(i);
      }
    }
    // ��x�������⴦��
    if (this.url.match(this.rep) == null) {
      _result[0] -= _result[4] - this.width >> 1; 
    }
	  return _result;
  },
  formatTime : function (num) {
    var _result = num > 60 ? 
      Math.floor(num/60) + '��' + num % 60 + '��' :
      num + '��';
    return _result;
  }
}

// �Զ�����
$(function () {
  var _cb_obj = {
    total : $('img.area').length,
    cur : 0,
    innerWidth : markHeat.width + 'px',
    innerHeight : '80%',
    href : '#con',
    inline : true,
    scrolling : false,
    rel : 'area_group',
    current : 'Step {current} / {total}',
    onComplete : function () {
      $('#cboxNext,#cboxPrevious,#cboxCurrent').show();
      $('#cboxCurrent').html('Step ' + _cb_obj.cur + ' / ' + _cb_obj.total);
    }
  };
  $('img.area').click( function (e) {
    var _arr = $(this).attr('name').split('#');
    _cb_obj.cur = $('img.area').index($(this)) + 1;
    _cb_obj.title = _arr[0] + ' �ڴ�ҳͣ����' + markHeat.formatTime(_arr[2]);
    $.colorbox(_cb_obj);
    markHeat.showArea($(this).attr('name'), $('#cboxLoadedContent').height());
  });
  // ��дcolorbox����һ����һ������
  $.colorbox.next = function (e) {
    if (_cb_obj.cur < _cb_obj.total) {
      $('img.area').eq(_cb_obj.cur).click();
    }
  }
  $.colorbox.prev = function (e) {
    if (_cb_obj.cur > 1) {
      $('img.area').eq(_cb_obj.cur - 2).click();
    }
  }
});
