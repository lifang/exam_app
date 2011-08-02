//var mh = 30;//最小高度
//var step = 1;//每次变化的px量
//var ms = 10;//每隔多久循环一次
//function toggle(o){
//  if (!o.tid)o.tid = "_" + Math.random() * 100;
//  if (!window.toggler)window.toggler = {};
//  if (!window.toggler[o.tid]){
//    window.toggler[o.tid]={
//      obj:o,
//      maxHeight:o.offsetHeight,
//      minHeight:mh,
//      timer:null,
//      action:1
//    };
//  }
//  o.style.height = o.offsetHeight + "px";
//  if (window.toggler[o.tid].timer)clearTimeout(window.toggler[o.tid].timer);
//  window.toggler[o.tid].action *= -1;
//  window.toggler[o.tid].timer = setTimeout("anim('"+o.tid+"')",ms );
//}
//function anim(id){
//  var t = window.toggler[id];
//  var o = window.toggler[id].obj;
//  if (t.action < 0){
//    if (o.offsetHeight <= t.minHeight){
//      clearTimeout(t.timer);
//      return;
//    }
//  }
//  else{
//    if (o.offsetHeight >= t.maxHeight){
//      clearTimeout(t.timer);
//      return;
//    }
//  }
//  o.style.height = (parseInt(o.style.height, 10) + t.action * step) + "px";
//  window.toggler[id].timer = setTimeout("anim('"+id+"')",ms );
//}