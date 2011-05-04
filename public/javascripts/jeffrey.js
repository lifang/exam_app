
close_question_info_id = 0
close_create_question_id = 0
close_edit_question_id = 0
function create_question(id){

    if (close_question_info_id != 0) {   //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }

    if (close_edit_question_id != 0) {   //关闭编辑框
        document.getElementById("question_info_"+close_edit_question_id).style.display="none";
        close_edit_question_id = 0;
    }

    if(close_create_question_id != 0){   
        if(close_create_question_id == id){
            document.getElementById("create_question_"+id).style.display="none";
            close_create_question_id = 0;
        }
        else{
            document.getElementById("create_question_"+close_create_question_id).style.display="none";
            document.getElementById("create_question_"+id).style.display="block";
            close_create_question_id = id;
        }
    }
    else{ 
        document.getElementById("create_question_"+id).style.display="block";
        close_create_question_id = id;
    }
}

function change_info(){
    if (close_edit_question_id != 0) {  //关闭编辑框
        document.getElementById("question_info_"+close_edit_question_id).style.display="none";
        close_edit_question_id = 0;
    }
    
    if (close_question_info_id != 0) {    //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    if (close_create_question_id != 0) {  //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    
    document.getElementById("change_info").style.display="block";
    document.getElementById("show_info").style.display="none";
}

function new_module(){
    if (close_edit_question_id != 0) {  //关闭编辑框
        document.getElementById("question_info_"+close_edit_question_id).style.display="none";
        close_edit_question_id = 0;
    }
    if (close_question_info_id != 0) {   //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    if (close_create_question_id != 0) {  //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    if(document.getElementById("new_module").style.display=="block"){
        document.getElementById("new_module").style.display="none";
    }else{
        document.getElementById("new_module").style.display="block";
    }
}
function close_new_module(){
    document.getElementById("new_module").style.display="none";
}

function question_info(id){      //onMouseOver
    if (close_edit_question_id != 0) {  //关闭编辑框
        document.getElementById("edit_question_"+close_edit_question_id).style.display="none";
        close_edit_question_id = 0;
    }
    if (close_create_question_id != 0) { //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    if (close_question_info_id != 0) {  //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    document.getElementById("question_info_"+id).style.display="block";
    close_question_info_id = id;
}

function edit_question(id){
    if (close_create_question_id != 0) {  //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    if (close_question_info_id != 0) { //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    
  if(close_edit_question_id != 0){
        if(close_edit_question_id == id){
            document.getElementById("edit_question_"+id).style.display="none";
            close_edit_question_id = 0;
       }
        else{
          document.getElementById("edit_question_"+close_edit_question_id).style.display="none";
            document.getElementById("edit_question_"+id).style.display="block";
            close_edit_question_id = id;
        }
  }
  else{
        document.getElementById("edit_question_"+id).style.display="block";
        close_edit_question_id = id;
    }
}




