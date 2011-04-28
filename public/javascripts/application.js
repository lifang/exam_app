// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function check(){
    
    var user_name= document.getElementById("session_user_name").value;
    
    if (user_name == null){
        
        document.getElementById("user_name").innerHTML="请输入正确的名字";
        return false;
    }

    

}

