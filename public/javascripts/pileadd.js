
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
    if (parseInt(accesstime) >parseInt( timeout)){
        alert("入场结束时间超过考试时长，请检查!");
        return false;
    }
//    js提供了parseInt()和parseFloat()两个转换函数
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
function test_exam(table_rows,type_name){
    var n = $(type_name+"_infoname"+table_rows).value;
    var mobile = $(type_name+"_infomobile"+table_rows).value;
    var email = $(type_name+"_infoemail"+table_rows).value;
    return test_exam_edit(n,mobile,email);
}
function add_item(table_id, url, update_div, examination_id,type_name){
    var table_rows = $("" + table_id).rows.length ;
    var otr = document.getElementById("" + table_id).insertRow(table_rows-2);
    otr.id = table_rows;
    var str = "<td colspan='4'><form accept-charset='UTF-8' action='"+ url +"' class='required-validate' ";
    str += "method='get' onsubmit='if (test_exam("+ otr.id +", \""+ type_name +"\")) {new Ajax.Updater(\""+ update_div +"\", \""+ url +"\", {asynchronous:true, evalScripts:true, method:\"get\", parameters:Form.serialize(this)});}; return false;'>";
    str += "<div style='margin:0;padding:0;display:inline'><input name='utf8' type='hidden' value='&#x2713;' />";
    str += "<input name='authenticity_token' type='hidden' value='UEvwUF56teT4A4h8yc2xE9kbGreWJEGaDJZgItFC3fw=' />";
    str += "</div>";
    str += "<input type='hidden' name='examination_id' id='examination_id' value='"+ examination_id +"'/>";
    str += "<table><tr><td><input type='text' name='"+type_name +"_infoname' id='"+type_name +"_infoname"+otr.id + "' class='required' size='30'/></td>";
    str += "<td><input type='text' name='"+type_name +"_infomobile' id='"+type_name +"_infomobile"+otr.id + "' class='required' size='30'/></td>";
    str += "<td><input type='text' name='"+type_name +"_infoemail' id='"+type_name +"_infoemail"+otr.id + "' class='required' size='30'/></td>";
    str += "<td><button type='submit'>创建</button></td></tr></table>";
    str += "</form></td>";
    otr.innerHTML = str;
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
    time_limit("timelimit");
}

function update_base_info(url) {
    new Ajax.Updater('base_info_div', ''+url,
    {asynchronous:true, evalScripts:true, method:'get',
        parameters:'authenticity_token=' + encodeURIComponent('50BAfYoKpsPM7ylg3Q62hfovb0rOif8TnQl+tOGfjKY=')});
}

function edit_exam(div,controller,exam_id,action){
   
    var n = $("name_"+exam_id).value;
    var mobile = $("miblephone_"+exam_id).value;
    var email = $("email_"+exam_id).value;
    if (test_exam_edit(n,mobile,email)){
        new Ajax.Updater(div+"_" + exam_id, "/"+controller+"/"+ exam_id +"/"+action,
        {
            asynchronous:true,
            evalScripts:true,
            method:'post',
            parameters:'name='+ n +'&mobilephone='+mobile +'&email='+ email +'&authenticity_token=' + encodeURIComponent('5kqVHCOuTTCFFQkywU0UzTAENJi1jcPs0+QKEpVa4lQ=')
        });
        return false;
    }   
}

function test_exam_edit(n,mobile,email){
    var myReg =new RegExp(/^\w+([-+.])*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/);
    var check_value = new RegExp(/[a-zA-Z0-9\_\u4e00-\u9fa5]/);
    var check_mobile = new RegExp(/^[0-9]{11,11}$/);
    if (n == null || n.length ==0||n.length>10){
        document.getElementById("nameErr").innerHTML="<font color = 'red'>用户名不能为空，长度不能超过10位字符</font>";
        return false;
    }else{
        if (check_value.test(n)) {
            document.getElementById("nameErr").innerHTML="";
            if(mobile==null ||mobile.length==0){
                document.getElementById("nameErr").innerHTML="<font color = 'red'>手机不能为空</font>";
                return false;
            }
            else{
                if (check_mobile.test(mobile)){
                    document.getElementById("nameErr").innerHTML="";
                    if (email == null || email.length ==0||email.length>20){
                        document.getElementById("nameErr").innerHTML="<font color = 'red'>邮箱不能为空，长度不能超过20位字符</font>";
                        return false;
                    } else {
                        if ( myReg.test(email)) {
                            document.getElementById("nameErr").innerHTML="";
                            return true;
                        } else{
                            document.getElementById("nameErr").innerHTML="<font color = 'red'>邮箱格式不对，请重新输入！</font>";
                            return false;
                        }
                    }
                }
                else{
                    document.getElementById("nameErr").innerHTML="<font color = 'red'>手机号为11位数字</font>";
                    return false;
                }
            }
        } else{
            document.getElementById("nameErr").innerHTML="<font color = 'red'>用户名不能包含非法字符</font>";
            return false;
        }
    } 
}
function show_name(info,passsowrd) {
    $(info).style.display ="block";
    $(passsowrd).style.display ="none";
}
function checkinfo(){
    var check_value = new RegExp(/[a-z0-9_]/g);
    var name=$("user_name").value;
    if (name== null || name.length ==0||name.length>10){
        document.getElementById("nameErr").innerHTML="用户名不能为空或长度不能超过10位字符";
        return false;
    }else{
        if (check_value.test(name)) {
            document.getElementById("nameErr").innerHTML="";
            return true;
        }
        else{
            document.getElementById("nameErr").innerHTML="用户名格式不正确";
            return false;
        }
    }
}
function check_password() {
    var password=$("user_password").value;
    var confirmation=$("user_password_confirmation").value;
    if (password == null || password.length ==0||password.length>40||password.length<6){
        document.getElementById("passwordErr").innerHTML="<font color = 'red'>密码不能为空，长度在6和20之间</font>";
        return false;
    } else	{
        document.getElementById("passwordErr").innerHTML="";
        if (confirmation != password){
            document.getElementById("confirmationErr").innerHTML="<font color = 'red'>两次输入的密码不一致，请重新输入</font>";
            return false;
        }else{
            document.getElementById("confirmationErr").innerHTML="";
            return ture;
        }
    }
}
close_question_info_id=0
function compare_value(id,compare_id){
    
    if (close_question_info_id != 0) {  //关闭查看框
        if (parseInt(compare_id)==0){
            document.getElementById("question_info_"+close_question_info_id).style.display="none";
            close_question_info_id = 0;
        }else{ 
            var arry=id.split("_");
            var i;
            for(i=1;i<arry.length;i++){
                var input_value=$("single_value_"+arry[i]).value;
                var fact_value=$("fact_value_"+arry[i]).value;
                if (parseInt(fact_value) < parseInt(input_value)||parseInt(input_value)<0||input_value==""){
                    $("if_submited_"+arry[i]).value =0;
                    $("flash_part_"+arry[i]).innerHTML="<font color = 'red'>您输入的数据与原数值不符</font>";
                    return false;
                }
                else{
                    $("flash_part_"+arry[i]).innerHTML="";
                    $("if_submited_"+arry[i]).value =1;
                    if (i==arry.length-1){
                        document.getElementById("question_info_"+close_question_info_id).style.display="none";
                        close_question_info_id = 0;
                        active_button();
                    }

                }
            }
        }
    }
    document.getElementById("question_info_"+id).style.display="block";
    close_question_info_id = id;
    active_button();
}
function active_button(){
     $("flash_notice").innerHTML="";
    var flag=0;
    var str=$("problem_id").value;
    var n=str.split(",");
    for(i=1;i<n.length;i++){
        value=$("single_value_"+n[i]).value;
        flag=1;
        if(value ==""){
            $("if_submited_"+n[i]).value =0;
            flag=0;
            $("button_id").disabled=true;
            return false;
        }
    }
    if(flag==1){
        button_status();
        if(button_status()){
            $("button_id").disabled=false;
        }
        else{
            $("flash_notice").innerHTML="<font color = 'red'>请检查批阅分数</font>";
            $("button_id").disabled=true;
        }
    }else{ 
        $("button_id").disabled=true;
    }
}
function button_status(){
    var str=$("problem_id").value;
    var  flag=0;
    var n=str.split(",");
    for(i=0;i<n.length-1;i++){
        var  value=$("if_submited_"+n[i+1]).value;
        flag=1;
        if(value==0){
            flag=0;
            return false;
        }
    }
    if (flag==1){
        return true;
    }
    else{
        return false;
    }
}
function exam_user_for_now(examination_id){
  {
        new Ajax.Updater("exam_user_list" , "/exam_user/exam_users/single_user",
        {
            asynchronous:true,
            evalScripts:true,
            method:'post',
            parameters:'id='+ examination_id +'&authenticity_token=' + encodeURIComponent('5kqVHCOuTTCFFQkywU0UzTAENJi1jcPs0+QKEpVa4lQ=')
        });
        return false;
    }
}
function file_exam_user(examination_id){
    var user_info=$("user_info").value;
  {
        new Ajax.Updater("add_failed" , "/exam_users/"+examination_id+"/login",
        {
            asynchronous:true,
            evalScripts:true,
            method:'post',
            parameters:'examination_id='+ examination_id +'&user_info='+ user_info +'&authenticity_token=' + encodeURIComponent('5kqVHCOuTTCFFQkywU0UzTAENJi1jcPs0+QKEpVa4lQ=')
        });
        return false;
    }
}
