/******************************************************************************
 * ����ͼ
 * @author Meathill
 * @version 0.2(2011-08-20)
 * ***************************************************************************/
/**
 * ���������û�����
 * @author Meathill
 * @version 0.1(2011-08-20)
 */
var ui = {
  height: 0,
  interval: 0,
  init : function () {
    // ����ѡ��
    $('#date')
      .datepicker({dateFormat: 'ymmdd', maxDate: '0d'})
      .val($.datepicker.formatDate('ymmdd', new Date()));
    $('#icon-calendar').click(function () {
      $('#date').datepicker('show');
    });
    // ��ť
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
    // ����iframe onload�¼�
    if ($.browser.msie) {
      var _ifr = $('#page')[0];
      _ifr.attachEvent('onload', ui.setMapHeight);
    }
    $('#url').keydown(ui.onKeyDown);
  },
  createHeatMap : function () {
    var target = $('#url').val();
    if (target == '' || target == 'http://') {
      alert('Ŀ��Url�������');
      $('#url').addClass('ui-state-error').focus();
      return;
    }
    // ��iframe�м���ҳ��
    $('#page').attr('src', '../cgi-bin/page_filter.cgi?page=' + target + '&ab=' + $('#ab').val() + '&d=' + $('#date').val());
    // ����flash
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
    // �������
    $('#panel').fadeOut();
    // ��ʾ״̬��
    $('#topbar').slideDown();
    $('#topbar .url').html($('#url').val()).click(function (evt) {
      if ($('#panel').css('display') == 'block') {
        $('#panel').fadeOut();
        $(this).attr('title', '����޸Ĳ���');
      } else {
        $('#panel').fadeIn();
        $(this).attr('title', '�ر�ѡ�����');
      }
    });
    // ��ʾ��߿�����
    // ��ʾiframe��
    $('#con, #map_con').removeClass('hide');
    
    // 30s���Զ�ȡ�Ѽ���ҳ��ĸ߶�
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

// �Զ�����
$(ui.init);