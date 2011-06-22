//验证注册按钮
function buttoncontrol(){  
    var sles=document.getElementsByName("checkbox");
    var all=document.getElementById("submit_button");
    all.className="reg_btn";
    for (var k=0;k<sles.length;k++) {
        if (sles[k].checked){
            all.className="reg_btn";
            document.getElementById("submit_button").disabled=false;
        } else {
            all.className="reg_btn_no";
            document.getElementById("submit_button").disabled=true;
        }
    }
}

//验证创建试卷
function check_paper_form(){
    return sumbit_form("paper_form", "paper_submit", "spinner_for_submit");
}
