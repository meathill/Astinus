/**
 * ���������
 * @author Meathill
 * @param Array arr �������ݵ�����
 * @param String color ��ʾ��ɫ���ַ������ԡ�#����ʼ
 * @param int id ����������
 */
function DataPanel(arr, color, id) {
  this.parent = null;
  this.moveTo = function (x, y) {
    this.body.css('left', x + 'px');
    this.body.css('top', y + 'px');
  }
  this.appendTo = function (parent) {
    this.parent = $(parent);
    this.parent.append(this.body);
  }
  this.setURLS = function (arr) {
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
  this.close = function (evt) {
    var id = parseInt($(this).parent().attr('id').substr(2));
    DataPanel.prototype.items[id].remove();
  }
  this.remove = function (evt) {
    this.body.remove();
  }
  this.show = function (evt) {
    var index = parseInt($(this).attr('index'));
    var parent = $(this).parent();
    parent.children('dd')
      .hide()
      .eq(index).show();
  }
  
  // ����ʹ��dl������ÿ��ģ�鶼��dt+dd
  var init = {'id': 'dp' + id,
              'class': 'DataPanel',
              'style': 'border-color:' + color + ';background:' + color}
  this.body = $('<dl>', init);
  for (var i = 0; i < this.list.length; i++) {
    init = {text: this.list[i],
            'index': i,
            click: this.show};
    this.body.append($('<dt>', init));
    this.body.append($('<dd>', {text: i}));
  }
  // �رհ�ť
  init = {'class': 'close',
          'href': 'javascript:void(0);',
          'title': '�ر�',
          click: this.close};
  var close = $('<a>', init).html('<img src="http://works.meathill.net/images/spacer.gif" width="12" height="12" />');
  close.appendTo(this.body);
  // Ĭ����ʾ���б�
  this.setURLS(arr);
  this.items[id] = this;
}
DataPanel.prototype.list = ['����', '��Ʒ', '����', 'ҳ������'];
DataPanel.prototype.items = [];
