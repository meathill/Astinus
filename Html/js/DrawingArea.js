/**
 * ���������
 * @author Meathill
 * @constructor
 * @param Array arr �������ݵ�����
 * @param String color ��ʾ��ɫ���ַ������ԡ�#����ʼ
 * @param int id ����������
 */
function DataPanel(arr, color, id) {
  this.appendTo = function (parent) {
    var parent = $(parent);
    parent.append(self.body);
    init.maxHeight = init.minHeight = self.body.height();
    self.body.resizable(init);
  }
  this.show = function (evt) {
    if (index != -1) {
      return;
    }
    self.body.height('');
    self.body.children('dd').hide();
    $(this).next().show();
    init.maxHeight = init.minHeight = self.body.height();
    self.body.resizable(init);
    // �Ƿ�Ҫ��������
    if ($(this).next().html() == '') {
      console.log('load data..');
      $(this).next().html('�������ݣ����Ժ�');
      index = parseInt($(this).attr('index'));
      var param = {r: self.r,
                   select: self.select + '.' + self.type[index],
                   w: $(window).width(),
                   d: self.date};
      $.get(self.url, param, self.onData);
    }
  }
  this.close = function (evt) {
    self.remove();
  }
  this.onData = function (data) {
    var result;
    if (data == '') {
      result = '���������';
    } else {
      var init = {'cellspacing': 1,
                  'cellpadding': 0,
                  'border': 0,
                  'width': '100%'}; 
      result = $('<table>', init);
      var arr = data.split('\n');
      for (var i = 0; i < arr.length; i++) {
        var row = arr[i].split(',');
        var tr = $('<tr>');
        tr.append($('<td>', {text: row[0]}));
        tr.append($('<td>', {text: row[1]}));
        tr.appendTo(result);
      }
    }
    self.body.children('dd').eq(index).empty().append(result);
    index = -1;
  }
  
  /**
   * @public
   */
  this.select = '';
  /**
   * @private
   */
  var self = this;
  var index = -1;
  // ����ʹ��dl������ÿ��ģ�鶼��dt+dd
  var init = {'id': 'dp' + id,
              'class': 'DataPanel ui-widget-content',
              'style': 'border-color:' + color + ';background:' + color};
  this.body = $('<dl>', init);
  for (var i = 0; i < this.list.length; i++) {
    init = {text: this.list[i],
            'index': i,
            click: this.show};
    this.body.append($('<dt>', init));
    this.body.append($('<dd>'));
  }
  // �϶���ť
  init = {'class': 'dragbar',
          'alt': '�϶�����'}
  var drag = $('<div>', init).html('<img src="http://works.meathill.net/images/spacer.gif" />');
  drag.appendTo(this.body);
  this.body.draggable({handle: '.dragbar', stack: '.DataPanel'});
  // �رհ�ť
  init = {'class': 'close',
          'href': 'javascript:void(0);',
          'title': '�ر�',
          click: this.close};
  var close = $('<a>', init).html('<img src="http://works.meathill.net/images/spacer.gif" width="12" height="12" />');
  close.appendTo(this.body);
  // Ĭ����ʾ���б�
  this.setURLS(arr);
  
  // ���ŵĳ�ʼ������
  init = {maxHeight: 0,
          minHeight: 0,
          minWidth: 300,
          alsoResize: '.dragbar'};
}
DataPanel.prototype.list = ['����', '��Ʒ', '����', 'ҳ������'];
DataPanel.prototype.type = ['url', 'product', 'title', 'page_type']
DataPanel.prototype.url = '';
DataPanel.prototype.r = '';
DataPanel.prototype.date = '';
DataPanel.prototype.moveTo = function (x, y) {
  this.body.css('left', x + 'px');
  this.body.css('top', y + 'px');
}
DataPanel.prototype.setURLS = function (arr) {
  var init = {'cellspacing': 1,
              'cellpadding': 0,
              'border': 0,
              'width': '100%'}
  var table = $('<table>', init);
  for (var i = 0; i < arr.length; i++) {
    var tr = $('<tr>');
    tr.append($('<td>', {text: arr[i].link}));
    tr.append($('<td>', {text: arr[i].num}));
    tr.appendTo(table);
  }
  var dd = this.body.children('dd').eq(0);
  dd.empty().append(table);
  dd.css('display', 'block');
}
DataPanel.prototype.remove = function (evt) {
  this.body.remove();
}
