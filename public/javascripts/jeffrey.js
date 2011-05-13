
close_question_info_id = 0
close_create_question_id = 0
close_edit_problem_id = 0
close_edit_block_id = 0
function create_question(id){

    if (close_edit_block_id != 0) {   //关闭模块编辑框
        document.getElementById("edit_block_"+close_edit_block_id).style.display="none";
        close_edit_block_id = 0;
    }
    
    if (close_question_info_id != 0) {   //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }

    if (close_edit_problem_id != 0) {   //关闭编辑框
        document.getElementById("edit_problem_"+close_edit_problem_id).style.display="none";
        close_edit_problem_id = 0;
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
    if (close_edit_block_id != 0) {   //关闭模块编辑框
        document.getElementById("edit_block_"+close_edit_block_id).style.display="none";
        close_edit_block_id = 0;
    }
    if (close_edit_problem_id != 0) {  //关闭编辑框
        document.getElementById("question_info_"+close_edit_problem_id).style.display="none";
        close_edit_problem_id = 0;
    }
    
    if (close_question_info_id != 0) {    //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    if (close_create_question_id != 0) {  //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    
    document.getElementById("paper_edit_info").style.display="block";
    document.getElementById("paper_show_info").style.display="none";
}

function new_module(){
    
    if (close_edit_block_id != 0) {   //关闭模块编辑框
        document.getElementById("edit_block_"+close_edit_block_id).style.display="none";
        close_edit_block_id = 0;
    }
    if (close_edit_problem_id != 0) {  //关闭编辑框
        document.getElementById("question_info_"+close_edit_problem_id).style.display="none";
        close_edit_problem_id = 0;
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
    if (close_edit_block_id != 0) {   //关闭模块编辑框
        document.getElementById("edit_block_"+close_edit_block_id).style.display="none";
        close_edit_block_id = 0;
    }
    if (close_edit_problem_id != 0) {  //关闭编辑框
        document.getElementById("edit_problem_"+close_edit_problem_id).style.display="none";
        close_edit_problem_id = 0;
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

function edit_problem(id){
    if (close_edit_block_id != 0) {   //关闭模块编辑框
        document.getElementById("edit_block_"+close_edit_block_id).style.display="none";
        close_edit_block_id = 0;
    }
    if (close_create_question_id != 0) {  //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    if (close_question_info_id != 0) { //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    
    if(close_edit_problem_id != 0){
        if(close_edit_problem_id == id){
            document.getElementById("edit_problem_"+id).style.display="none";
            close_edit_problem_id = 0;
        }
        else{
            document.getElementById("edit_problem_"+close_edit_problem_id).style.display="none";
            document.getElementById("edit_problem_"+id).style.display="block";
            close_edit_problem_id = id;
        }
    }
    else{
        document.getElementById("edit_problem_"+id).style.display="block";
        close_edit_problem_id = id;
    }
}

function edit_block(id){
    if (close_create_question_id != 0) {  //关闭新建框
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    if (close_question_info_id != 0) { //关闭查看框
        document.getElementById("question_info_"+close_question_info_id).style.display="none";
        close_question_info_id = 0;
    }
    if (close_edit_problem_id != 0) {  //关闭编辑框
        document.getElementById("edit_problem_"+close_edit_problem_id).style.display="none";
        close_edit_problem_id = 0;
    }
    if(close_edit_block_id != 0){
        if(close_edit_block_id == id){
            document.getElementById("edit_block_"+id).style.display="none";
            close_edit_block_id = 0;
        }
        else{
            document.getElementById("edit_block_"+close_edit_block_id).style.display="none";
            document.getElementById("edit_block_"+id).style.display="block";
            close_edit_block_id = id;
        }
    }
    else{
        document.getElementById("edit_block_"+id).style.display="block";
        close_edit_block_id = id;
    }
}


function already_answer(){
    elements = document.forms["answer_box"].elements;

    for(i = 0;i<elements.length;i++){
        if(elements[i].type=="radio"){
            if(elements[i].checked==true){
                id=elements[i].id.substring(0,15);
                document.getElementById(id).innerHTML=('你选择了答案:'+elements[i].value);
            }
        }
    }
}
var signed_id = 0;

function check_all(){
    var elements = document.forms["answer_box"].elements;
    for(var i = 0;i<elements.length;i++){
        if(elements[i].type=="radio"){
            var id=elements[i].id.substring(0,15);
            if(elements[i].checked==true){              
                document.getElementById(id+'_sign').innerHTML=('已答:（ '+elements[i].value+' )');
                signed_id = id;
            }
            else{
                if(elements[i].id.substring(0,15)!=signed_id){
                    document.getElementById(id+'_sign').innerHTML=('未答 ');
                }
            }
        }
    }
    signed_id = 0;
}



//function checkup(obj) {
//    var i,myObj;
//    myObj=document.getElementsByName(obj);
//    for(i=0;i<myObj.length;i++){
//        if(myObj[i].checked){
//            document.getElementById('your_answer#{problem.attributes["id"]}').innerHTML=('你选择了答案:');
//        }
//    }
//    }
////if(i>=myObj.length){
////alert("没有选择任何对象");
////} else {
////alert("选择的是第："+(i+1)+"个");
////}
//}




