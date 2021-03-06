function check_new(){ 
    var username=document.getElementById("user_name").value;
    var strEmail=document.getElementById("user_email").value;
    var password=document.getElementById("user_password").value;
    var confirmation=document.getElementById("user_password_confirmation").value;
    var myReg =new RegExp(/^\w+([-+.])*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/);
    var check_value = new RegExp(/[a-z0-9_]/g);
    var strEmail=document.getElementById("user_email").value;
    if (strEmail == null || strEmail.length ==0||strEmail.length>50){
        document.getElementById("emailErr").innerHTML="<font color = 'red'>邮箱不能为空，长度不能超过50</font>";
        return false;
    } else {
        if ( myReg.test(strEmail)) {
            document.getElementById("emailErr").innerHTML="";
        } else{
            document.getElementById("emailErr").innerHTML="<font color = 'red'>邮箱格式不对，请重新输入！</font>";
            return false;
        }
    }
    
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
        }
    }
    if (username == null || username.length ==0||username.length>30){
        document.getElementById("usernameErr").innerHTML="<font color = 'red'>用户名不能为空，长度不能超过30</font>";
        return false;
    }else{
        if (check_value.test(username)) {
            document.getElementById("usernameErr").innerHTML="";
        } else{
            document.getElementById("usernameErr").innerHTML="<font color = 'red'>用户名只能由字母，数字和下划线组成</font>";
            return false;
        }
    }
    alert(0);
}

function signin_page(){
    var check_value =new RegExp(/^\w+([-+.])*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/);
    var user_name= document.getElementById("session_email").value;
    var user_password= document.getElementById("session_password").value;
    if (user_name == null||user_name.length==0|| check_value.test(user_name)==false){
        document.getElementById("error_msg").style.color="#FF0000"
        document.getElementById("error_msg").innerHTML="请输入邮箱或格式不正确";
        return false;
    }
    else {
        document.getElementById("error_msg").innerHTML="";
        if(user_password == null||user_password.length==0){
            document.getElementById("error_msg").style.color="#FF0000"
            document.getElementById("error_msg").innerHTML="请输入正确的密码";
            return false;
        }
    }
}

function tab(tag, n){
    for(var i=1; i <= n; i++){
        document.getElementById("li_tab" + i).className = "";
        document.getElementById("div_tab" + i).className = "";
    }
    document.getElementById("li_" + tag).className = "actived";
    document.getElementById("div_" + tag).className = "actived";

}
function stall(checkstatus,checkb){
    var d=document.getElementsByName(checkb);
    var checked_ids = new Array();
    for(var i=0; i<d.length; i++){
        if (d[i].disabled == false) {
            d[i].checked=checkstatus;

        }
        if (d[i].checked) {
            checked_ids.push(d[i].value);
        }

    }
    if (checked_ids==""){
        $("exam_g").disabled=true;
    }else{
        $("exam_g").disabled =false;
    }
    document.getElementById("exam_getvalue").value = checked_ids;
}
function create_ex(checkbox){
    var sles=document.getElementsByName(checkbox);
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }
        if (checked_ids==""){
            $("exam_g").disabled=true;
        }else{
            $("exam_g").disabled =false;
        }
    }

    document.getElementById("exam_getvalue").value = checked_ids;
}


function select_month(year) {
    var all_select = true;
    var y = document.getElementsByName("year");
    if (y != null) {
        for (var m=0; m<y.length; m++) {
            var months = document.getElementsByName(year);
            if (y[m].id == "year_" + year) {
                if (months != null) {
                    for (var i=0; i<months.length; i++) {
                        months[i].checked = y[m].checked;
                    }
                }
            }
            if (y[m].checked == false) {
                all_select = false;
            }
        }
    }
    var all = document.getElementById("year_all");
    if (all_select) {
        all.checked = true;
    } else {
        all.checked = false;
    }
}

function select_all() {
    var all = document.getElementById("year_all");
    var y = document.getElementsByName("year");
    if (y != null) {
        for (var m=0; m<y.length; m++) {
            y[m].checked = all.checked;
            var months = document.getElementsByName(y[m].id.split("year_")[1]);
            if (months != null) {
                for (var i=0; i<months.length; i++) {
                    months[i].checked = y[m].checked;
                }
            }
        }
    }
}

function select_year(year) {
    var year_select = true;
    var all_select = true;
    var y = document.getElementsByName("year");
    var months = document.getElementsByName(year);
    if (months != null) {
        for (var i=0; i<months.length; i++) {
            if (months[i].checked == false) {
                year_select = false;
                break;
            }
        }
    }
    var current_year = document.getElementById("year_"+year);
    if (year_select) {
        current_year.checked = true;
    } else {
        current_year.checked = false;
    }
    if (y != null) {
        for (var k=0; k<y.length; k++) {
            if (y[k].checked == false) {
                all_select = false;
                break;
            }
        }
    }
    var all = document.getElementById("year_all");
    if (all_select) {
        all.checked = true;
    } else {
        all.checked = false;
    }
}

function export_info() {
    var all = document.getElementById("year_all");
    var all_flag = false;
    if (all != null && all.checked == true) {
        all_flag = true;
    }
    var year_arr = "";
    var y = document.getElementsByName("year");
    if (y != null) {
        for (var k=0; k<y.length; k++) {
            var current_year = y[k].id.split("year_")[1];
            if (y[k].checked == true) {
                year_arr += current_year + ",1,2;";
            } else {
                var months = document.getElementsByName(y[k].id.split("year_")[1]);
                if (months != null) {
                    var month_arr = "";
                    for (var i=0; i<months.length; i++) {
                        if (months[i].checked == true) {
                            if (month_arr != "") {
                                month_arr += ",";
                            }
                            month_arr += months[i].id.split(current_year + "_")[1];
                        }
                    }
                    if (month_arr != "") {
                        year_arr += current_year + "," + month_arr + ";";
                    }
                }
            }
        }
    }
    if (all_flag == false && month_arr == "") {
        alert("请选择您要导出哪一时段的用户");
    } else {
        new Ajax.Updater("export_div", "/users/do_export_info",
        {
            asynchronous:true,
            evalScripts:true,
            method:"post",
            parameters:"all="+all_flag +"&year_arr="+year_arr+"&authenticity_token=" + encodeURIComponent('BgLpQ3SADBr4tuiYZOJeoOvY4VOHogJvqQEpMwYVBM4=')
        });
        return false;
    }
}

