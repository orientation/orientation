$.fn.extend({
  insertAtCaret: function(myValue){
  var obj;
  if( typeof this[0].name !='undefined' ) obj = this[0];
  else obj = this;

  // NOTE: this only works with Firefox and Webkit
  var startPos = obj.selectionStart;
  var endPos = obj.selectionEnd;
  var scrollTop = obj.scrollTop;
  obj.value = obj.value.substring(0, startPos)+myValue+obj.value.substring(endPos,obj.value.length);
  obj.focus();
  obj.selectionStart = startPos + myValue.length;
  obj.selectionEnd = startPos + myValue.length;
  obj.scrollTop = scrollTop;
 }
})