
function sltall(checkstatus){
    var d=document.getElementsByName("check_b");
    var i;
    var checked_ids = new Array();
    for(i=0;i<d.length;i++){
        d[i].checked=checkstatus;
        checked_ids.push(d[i].value);
    }
    document.getElementById("exam_getvalue").value = checked_ids;
}
function create_exam(){
    var sles=document.getElementsByName("check_b");
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {      
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }       
    }
    document.getElementById("exam_getvalue").value = checked_ids;
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
function see_result(name){
    var sles=document.getElementsByName(name);
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }
    }
    document.getElementById("examplan_see_result").value = checked_ids;
    alert(document.getElementById("examplan_see_result").value);
}
function selectminute(name){
    var checked_ids = new Array();
    var sles = document.getElementById(name).value;
    if (sles< 0){
        alert("请选择正确的分钟!")
    }
    else{
        checked_ids.push(sles);
        document.getElementById("examplan_selectvalue").value=checked_ids;
    }
}
function selecttime(name){
    var checked_ids = new Array();
    var sles = document.getElementById(name).value;
    if (sles< 0){
        alert("请选择正确的时间!")
    }
    else{
        checked_ids.push(sles);
        document.getElementById("examplan_see_result").value=checked_ids;
    }
}

//    var sles=document.getElementById(name).options[document.getElementById(name).selectedIndex].text;
function compare_value() {
    var accesstime=document.getElementById("accesstime").value;
    var timeout=document.getElementById("timeout").value;
    if (accesstime > timeout){
        alert("入场结束时间超过考试时长，请检查!");
    }
}
function getbutton(name) {
    var all=document.getElementById(name);
    document.getElementById("buttonvalue").value=all.value;
}
function showpartial(name){
    var sles=document.getElementsByName(name);
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked){
            checked_ids.push(sles[i].value);
            if (checked_ids==1){
                document.getElementById("login_block").style.display="block";
                document.getElementById("leadin").style.display="none";
            }
            else
            {       
                document.getElementById("login_block").style.display="none";
                document.getElementById("leadin").style.display="block";
            }
        }
    }
}
function add_item(){
    var otr = document.getElementById("add").insertRow(-1);
    otr.id = $('add').rows.length ;
    var otd1 = document.createElement("td");
    var checkTd=document.createElement("td");
    checkTd.innerHTML = "<a href=javascript:delete_item("+otr.id+")>删除</a>";
    otd1.innerHTML = '<input type="text"  name='+"infoName" +otr.id+ ' id="infoName_txt'+(document.getElementById('add').rows.length-1)+'" size="30" value=""/>';
    var otd2 = document.createElement("td");
    otd2.innerHTML = '<input type="text"  name='+"infomobile" +otr.id+' id="infoValue_txt'+($('add').rows.length-1)+'"  size="30" value=""/>';
    var otd3 = document.createElement("td");
    otd3.innerHTML = '<input type="text"   name='+"infoemail" +otr.id+' id="infoValue_txt'+($('add').rows.length-1)+'"  size="30" value=""/>';
    otr.appendChild(otd1);
    otr.appendChild(otd2);
    otr.appendChild(otd3);
    otr.appendChild(checkTd);
 document.getElementById("rows").value=document.getElementById("add").rows.length
}
function delete_item(id){
    var c = document.getElementById(id);
    document.getElementById("add").deleteRow(c);
     document.getElementById("rows").value=document.getElementById("add").rows.length
}
