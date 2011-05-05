
function sltall(checkstatus){
  var d=document.getElementsByName("check_b");
  var i;
var checked_ids = new Array();
  for(i=0;i<d.length;i++){
      d[i].checked=checkstatus;
  checked_ids.push(d[i].value);
  }
 
     document.getElementById("deleteall_delete_all").value = checked_ids;
}
function create_exam(){
    var sles=document.getElementsByName("check_b");
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {      
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }       
    }
    document.getElementById("deleteall_delete_all").value = checked_ids;
}