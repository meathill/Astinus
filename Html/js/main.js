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
  interval: 0,
  rec: '',
  ab: '',
  date: '',
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
    $('#topbar .url').click(function (evt) {
      if ($('#panel').css('display') == 'none') {
        $('#panel').fadeIn();
        $(this).attr('title', '�ر�ѡ�����');
      } else {
        $('#panel').fadeOut();
        $(this).attr('title', '����޸Ĳ���');
      }
    });
    // ����iframe onload�¼�
    if ($.browser.msie) {
      var _ifr = $('#page')[0];
      _ifr.attachEvent('onload', ui.setMapHeight);
    }
    $('#url').keydown(ui.onKeyDown);
  },
  createHeatMap : function () {
    var target = utils.correctURL($('#url').val());
    if (target == '' || target == 'http://') {
      alert('Ŀ��Url�������');
      $('#url').addClass('ui-state-error').focus();
      return;
    }
    $('#url').html(target);
    // ��iframe�м���ҳ��
    if (target != ui.rec || $('#ab').val() != ui.ab || $('#date').val() != ui.date) {
      ui.rec = target, ui.ab = $('#ab').val(), ui.date = $('#date').val();
      $('#page').attr('src', '../cgi-bin/page_filter.cgi?page=' + ui.rec + '&ab=' + ui.ab + '&d=' + ui.date);
    }
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
    $('#topbar .url').html(target);
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
var utils = {
  /**
   * ��������������url����ĺϷ��ԣ����Զ�����
   * 1 �Ƿ���ȷ����http://
   * 2 �Ƿ����2��http://
   * 3 �Ƿ�ʹ��/��β
   * @author Meathill
   * @version 0.1(2011-08-25)
   * @param {String} url �û������url
   * @return {String} ��֤���Զ��������url
   */
  correctURL : function (url) {
    // �Ƿ���ȷ����http://
    if (url.substr(0, 7) != 'http://') {
      url = 'http://' + url;
    }
    // �Ƿ����2��http://
    url = url.replace(/(https?:\/\/)+/, '$1');
    // �Ƿ�ʹ��/��β
    var tail =url.substr(url.lastIndexOf('/') + 1); 
    if (tail.indexOf('?') == -1 && tail.charAt(tail.length - 1) != '/') {
      url += '/';
    }
    return url;
  }
  
}
// �Զ�����
$(ui.init);