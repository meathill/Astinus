/**
 * 数据面板类
 * @author Meathill
 * @param Array arr 生成数据的数组
 * @param String color 表示颜色的字符串，以“#”开始
 * @param int id 该面板的索引
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
  
  // 主体使用dl，里面每个模块都是dt+dd
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
  // 关闭按钮
  init = {'class': 'close',
          'href': 'javascript:void(0);',
          'title': '关闭',
          click: this.close};
  var close = $('<a>', init).html('<img src="http://works.meathill.net/images/spacer.gif" width="12" height="12" />');
  close.appendTo(this.body);
  // 默认显示的列表
  this.setURLS(arr);
  this.items[id] = this;
}
DataPanel.prototype.list = ['链接', '产品', '标题', '页面类型'];
DataPanel.prototype.items = [];
