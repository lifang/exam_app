// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function check(){
    
    var user_name= document.getElementById("session_username").value;
    var user_password= document.getElementById("session_password").value;
    if (user_name == null||user_name.length==0){
        document.getElementById("session_username").style.color="#ff0000"
        document.getElementById("session_username").value="请输入正确的名字";
        return false;
    }
    else{
        if(user_password == null||user_password.length==0){
            document.getElementById("session_password").style.color="#ff0000"
            document.getElementById("session_password").value="请输入正确的密码";
        }
    }

    

}

