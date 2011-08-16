function addFlash() {
  if ($("#url").val() != '') {
    _rec = $('#url').val();
    $('#page').attr('src', '../cgi-bin/page_filter.cgi?page=' + _rec + '&ab=' + $('#ab').val() + '&d=' + $('#date').val());
    // 插入flash
    var _flash_vars = {
      r: $('#url').val(),
      u: $('#tourl').val(),
      d: $('#date').val(),
      b: $('#btype').val(),
      ab: $('#ab').val(),
      nocache: $('#cache').prop('checked') ? 0 : 1,
      visitor: $('#oldnew').val()
    };
    var _param = {allowScriptAccess:'always', wmode:'transparent'};
    swfobject.embedSWF("../swf/clickHeatMap.swf", "map", "100%", _height, "10.3", "../swf/expressInstall.swf", _flash_vars, _param);
    $('#map_con').show();
    // 30s后自动取已加载页面的高度
    _interval = setInterval(ui.setMapHeight, 30000);
  }
}
var _rec, _height, _interval;
var ui = {
  onKeyDown : function (evt) {
    if (evt && evt.keyCode == 13) {
      addFlash();
    }
  },
  getScroll : function () {
    return document.documentElement.scrollTop || document.body.scrollTop;
  },
  toggleHeatMap : function () {
    if ($('#map_con').css('visibility') == 'visible'){
      $('#map_con, #map, #cover').css('visibility', 'hidden');
    } else {
      $('#map_con, #map, #cover').css('visibility', 'visible');
    }
  },
  setMapHeight : function () {
    clearInterval(_interval);
    var _ifr = $('#page')[0], _h = 0;
    /*if (!window.opera) {
      if (_ifr.contentDocument && _ifr.contentDocument.body.offsetHeight)
        _h = _ifr.contentDocument.body.offsetHeight; //FF NS
      else if(_ifr.Document && _ifr.Document.body.scrollHeight)
        _h = _ifr.Document.body.scrollHeight;//IE
    } else {
      if(_ifr.contentWindow.document && _ifr.contentWindow.document.body.scrollHeight)
        _h = _ifr.contentWindow.document.body.scrollHeight;//Opera
    }*/
    _h = $('#page').contents().height();
    $('#page, #cover').height(_h);
  }
}
$(function () {
  $('#date').val($.datepicker.formatDate('ymmdd', new Date()));
  $('#date').datepicker({ dateFormat: 'ymmdd', maxDate: '0d' });
  $('body').css('padding-top', $('#topbar').outerHeight() + 'px');
  $('#advance').click(function () {
    if ($(this).prop('checked')){
      $('#advpanel').show();
    } else {
      $('#advpanel').hide();
    }
  });
  _height = $(window).height() - $('#topbar').outerHeight();
  $('#map_con').height(_height).css('top', $('#topbar').outerHeight() + 'px');
  // 侦听iframe onload事件
  var _ifr = $('#page')[0];
  if ($.browser.msie) {
    _ifr.attachEvent('onload', ui.setMapHeight);
  }
  $('#url').change(ui.onKeyDown);
});