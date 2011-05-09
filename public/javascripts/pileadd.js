function piledelete(){
    var sles=document.getElementsByName("check_b");
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }
    }
    document.getElementById("deleteall_delete_all").value = checked_ids;
}
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
function radiovalue(name){
    var sles=document.getElementsByName(name);
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }
    }
    document.getElementById("examplan_radiovalue").value = checked_ids;
}
function radiovalue(name){
    var sles=document.getElementsByName(name);
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }
    }
    document.getElementById("examplan_see_result").value = checked_ids;
}
function selectvalue(name){
    var checked_ids = new Array();
    var sles = document.getElementById(name).value;
    if (sles< 0){
        alert("请选择正确的时间或分钟!")
    }
    else{
        checked_ids.push(sles);
        document.getElementById("examplan_selectvalue").value=checked_ids;
    }
}
function time_limit(name){
    var sles=document.getElementsByName(name);
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked){
        checked_ids.push(sles[i].value);
        if (checked_ids==1){
            document.getElementById("time").disabled=false;
            document.getElementById("hour").disabled=false;
            document.getElementById("minute").disabled=false;
        }
        else {
            document.getElementById("time").disabled=true;
            document.getElementById("hour").disabled=true;
            document.getElementById("minute").disabled=true;
        }
        }
    }

 

//    var sles=document.getElementById(name).options[document.getElementById(name).selectedIndex].text;
}