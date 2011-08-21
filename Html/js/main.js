/******************************************************************************
 * 热区图
 * @author Meathill
 * @version 0.2(2011-08-20)
 * ***************************************************************************/
/**
 * 处理界面和用户交互
 * @author Meathill
 * @version 0.1(2011-08-20)
 */
var ui = {
  height: 0,
  interval: 0,
  init : function () {
    // 日期选项
    $('#date')
      .datepicker({dateFormat: 'ymmdd', maxDate: '0d'})
      .val($.datepicker.formatDate('ymmdd', new Date()));
    $('#icon-calendar').click(function () {
      $('#date').datepicker('show');
    });
    // 按钮
    $('#panel button')
      .button()
      .click(ui.createHeatMap);
    $('#options_btn')
      .button({icons: { primary: "ui-icon-gear" }})
      .click(function (evt) { $('#options').slideToggle(); });
    $('#map_visible')
      .button()
      .click(ui.toggleHeatMap);
    $('#topbar button').button({
      icons: { primary: 'ui-icon-triangle-1-n'},
      text: false
    }).click(function (evt) {
      $('#topbar').animate({top: '-25px'}, function () {
        $(this).one('mouseover', function (evt) {
          $(this).animate({top: '0px'});
        })
      });
    });
    // 侦听iframe onload事件
    if ($.browser.msie) {
      var _ifr = $('#page')[0];
      _ifr.attachEvent('onload', ui.setMapHeight);
    }
    $('#url').keydown(ui.onKeyDown);
  },
  createHeatMap : function () {
    var target = $('#url').val();
    if (target == '' || target == 'http://') {
      alert('目标Url输入错误');
      $('#url').addClass('ui-state-error').focus();
      return;
    }
    // 在iframe中加载页面
    $('#page').attr('src', '../cgi-bin/page_filter.cgi?page=' + target + '&ab=' + $('#ab').val() + '&d=' + $('#date').val());
    // 插入flash
    var flashVars = {
      r: target,
      u: $('#tourl').val(),
      d: $('#date').val(),
      b: $('#btype').val(),
      ab: $('#ab').val(),
      nocache: $('#cache').prop('checked') ? 0 : 1,
      visitor: $('#oldnew').val()
    };
    var param = {allowScriptAccess:'always', wmode:'transparent'};
    swfobject.embedSWF("../swf/clickHeatMap.swf", "map", "100%", "100%", "10.3", "../swf/expressInstall.swf", flashVars, param);
    $('#map_con').show();
    // 隐藏面板
    $('#panel').fadeOut();
    // 显示状态条
    $('#topbar').slideDown();
    $('#topbar .url').html($('#url').val()).click(function (evt) {
      if ($('#panel').css('display') == 'block') {
        $('#panel').fadeOut();
        $(this).attr('title', '点击修改参数');
      } else {
        $('#panel').fadeIn();
        $(this).attr('title', '关闭选项面板');
      }
    });
    // 显示侧边控制栏
    // 显示iframe等
    $('#con, #map_con').removeClass('hide');
    
    // 30s后自动取已加载页面的高度
    ui.interval = setInterval(ui.setMapHeight, 30000);
  },
  onKeyDown : function (evt) {
    $(evt.target).removeClass('ui-state-error');
    if (evt && evt.keyCode == 13) {
      ui.createHeatMap();
    }
  },
  getScroll : function () {
    return document.documentElement.scrollTop || document.body.scrollTop;
  },
  toggleHeatMap : function (evt) {
    if ($('#map_con').css('visibility') == 'visible'){
      $('#map_con, #map, #cover').css('visibility', 'hidden');
    } else {
      $('#map_con, #map, #cover').css('visibility', 'visible');
    }
  },
  setMapHeight : function () {
    clearInterval(ui.interval);
    var _ifr = $('#page')[0], _h = 0;
    _h = $('#page').contents().height();
    $('#page, #cover').height(_h);
  }
}

// 自动运行
$(ui.init);