
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
                document.getElementById("accesstime").disabled=false;
            }
            else {
                document.getElementById("time").disabled=true;
                document.getElementById("hour").disabled=true;
                document.getElementById("minute").disabled=true;
                document.getElementById("accesstime").disabled=true;
            }
        }
    }

    document.getElementById("examplan_radiovalue").value = checked_ids;



//    var sles=document.getElementById(name).options[document.getElementById(name).selectedIndex].text;

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
    document.getElementById("login_form_value").value = "";
    document.getElementById("leadin_form_value").value = "";
    var login_form = $("login_form");
    var leadin_form = $("leadin_form");
    var text= new String();
    document.getElementById("textarea").value = "" ;
    if ($("login_block").style.display != "none") {
        document.getElementById("login_form_value").value = name;
        for (var i=1;i<=$("add").rows.length;i++){
            if ($("infoname"+i).value!="" && $("infomobile"+i).value!=""&& $("infoemail"+i).value!=""){
                text +=$("infoname"+i).value + ","+$("infomobile"+i).value + ","+$("infoemail"+i).value+";";
            }
        }
        document.getElementById("textarea").value = text;
        //login_form.submit();
    } else {

        document.getElementById("leadin_form_value").value = name;
        //leadin_form.submit();
    }
login_form.submit();

}
function showpartial(name){
    var sles=document.getElementsByName(name);
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked==true){
            if (sles[i].value==1){
                document.getElementById("login_block").style.display="block";
                document.getElementById("leadin_div").style.display="none";
            }
            else
            {       
                document.getElementById("login_block").style.display="none";
                document.getElementById("leadin_div").style.display="block";
            }
        }
    }
}
function add_item(table_id, url, update_div, examination_id){
    var table_rows = $("" + table_id).rows.length ;
    var otr = document.getElementById("" + table_id).insertRow(table_rows-2);
    otr.id = table_rows;
    var str = "<td colspan='4'><form accept-charset='UTF-8' action='"+ url +"' class='required-validate'";
    str += "method='post' onsubmit='new Ajax.Updater(\""+ update_div +"\", \""+ url +"\", {asynchronous:true, evalScripts:true, method:\"get\", parameters:Form.serialize(this)}); return false;'>";
    str += "<div style='margin:0;padding:0;display:inline'><input name='utf8' type='hidden' value='&#x2713;' />";
    str += "<input name='authenticity_token' type='hidden' value='UEvwUF56teT4A4h8yc2xE9kbGreWJEGaDJZgItFC3fw=' />";
    str += "</div>";
    str += "<input type='hidden' name='examination_id' id='examination_id' value='"+ examination_id +"'/>";
    str += "<table><tr><td><input type='text' name='infoname' id='infoname1' class='required' size='30'/></td>";
    str += "<td><input type='text' name='infomobile' id='infomobile1' class='required' size='30'/></td>";
    str += "<td><input type='text' name='infoemail' id='infoemail1' class='required' size='30'/></td>";
    str += "<td><button type='submit'>创建</button></td></tr></table>";
    str += "</form></td>";

    otr.innerHTML = str;

    /*var checkTd=document.createElement("td");
    checkTd.innerHTML = "<a href=javascript:delete_item("+otr.id+")>删除</a>";
    otd1.innerHTML = '<input type="text"  name='+"infoname" +otr.id+ ' id='+"infoname" +otr.id+ ' size="30" value=""/>';
    var otd2 = document.createElement("td");
    otd2.innerHTML = '<input type="text"  name='+"infomobile" +otr.id+' id='+"infomobile" +otr.id+'  size="30" value=""/>';
    var otd3 = document.createElement("td");
    otd3.innerHTML = '<input type="text"   name='+"infoemail" +otr.id+' id='+"infoemail" +otr.id+'  size="30" value=""/>';
    otr.appendChild(otd1);
    otr.appendChild(otd2);
    otr.appendChild(otd3);
    otr.appendChild(checkTd); */
    document.getElementById(table_id + "_rows").value=document.getElementById("" + table_id).rows.length;
}
function delete_item(id){
    var c = document.getElementById(id);
    document.getElementById("add").deleteRow(c);
    document.getElementById("rows").value=document.getElementById("add").rows.length
}

function change_paper() {
    var change_papers_div = $("change_papers_div").style;
    if (change_papers_div.display == "none") {
        change_papers_div.display = "block";
    } else {
        change_papers_div.display = "none";
    }
}

function exam_setting() {
    var exam_more_setting_div = $("exam_more_setting_div").style;
    var exam_more_setting_btn = $("exam_more_setting_btn");
    if (exam_more_setting_div.display == "none") {
        exam_more_setting_div.display = "block";
        exam_more_setting_btn.value = "-收起";
    } else {
       exam_more_setting_div.display = "none";
        exam_more_setting_btn.value = "+高级";
    }
}

function edit_exam_info() {
    $("edit_exam_base_info").style.display = "block";
    $("exam_base_info").style.display = "none";
}
function show_exam_info() {
    $("edit_exam_base_info").style.display = "none";
    $("exam_base_info").style.display = "block";
}