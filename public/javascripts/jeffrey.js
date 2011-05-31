
close_question_info_id = 0
close_create_question_id = 0
close_edit_problem_id = 0
close_edit_block_id = 0
function create_question(id, paper_id){

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
        if(close_create_question_id != id){
            document.getElementById("create_question_"+close_create_question_id).style.display="none";
            document.getElementById("create_question_"+id).style.display="block";
            close_create_question_id = id;
            get_question_type(id, paper_id, null, "new_problem_");
        }
    }
    else{
        document.getElementById("create_question_"+id).style.display="block";
        close_create_question_id = id;
        get_question_type(id, paper_id, null, "new_problem_");
    }
}

//将选中的题目的类型提交给新创建试题块的type隐藏域
function get_question_type(block_id, paper_id, correct_type, remote_div) {
    var problem_type = "";
    var question_type = "";
    var types = document.getElementsByName("type_radio_" + block_id);

    for (var i=0; i<types.length; i++) {
        if (types[i].checked == true) {
            problem_type = types[i].value;
        }
    }
    $("real_type_" + block_id).value = problem_type;
    $("choose_que_type_div_" + block_id).style.display = "none";
    if (correct_type == null) {
        question_type = problem_type;
    } else {
        question_type = correct_type;
    }
    if (remote_div == "remote_que_div_") {
        $("choose_coll_que_" + block_id).style.display = "none";
        $("choose_coll_que_link_" + block_id).style.display = "none";
    }
    new Ajax.Updater("" + remote_div + block_id, "/paper_blocks/" + block_id + "/choose_type",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'paper_id=' + paper_id + '&problem_type=' + problem_type + '&question_type='+ question_type +
        '&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

//增加综合题的小题
function new_question(block_id) {
    var hash_str = "{1=>1";
    if ($("problem_description")!= null && $("problem_description").value != "") {
        hash_str += ",|,diescription=>"+  $("problem_description").value + "";
    }
    hash_str += ",|,correct_type=>"+  $("problem_correct_type").value + "";
    hash_str += ",|,problem_attr_sum=>"+  $("problem_attr_sum").value + "";
    var attr_value = "";
    var attr_answer ="";
    if (parseFloat($("problem_correct_type").value) == 0) {
        for (var i=1; i<=parseFloat($("problem_attr_sum").value); i++) {
            attr_value += $("problem_attr" + i + "_value").value;
            if (i < parseFloat($("problem_attr_sum").value)) {
                attr_value += ";|;"
            }
            var attr_key = document.getElementsByName("attr_key");
            if (attr_key != null) {
                for (var j=0; j<attr_key.length; j++) {
                    if (parseFloat(attr_key[j].value) == i && attr_key[j].checked == true) {
                        attr_answer = $("problem_attr" + i + "_value").value;
                    }
                }
            }
        }
            
    } else if (parseFloat($("problem_correct_type").value) == 1) {
        for (var k=1; k<=parseFloat($("problem_attr_sum").value); k++) {
            attr_value += $("problem_attr" + k + "_value").value;
            if (k < parseFloat($("problem_attr_sum").value)) {
                attr_value += ";|;"
            }
            var more_attr_key = document.getElementsByName("attr" + k + "_key");
            if (more_attr_key[0].checked == true) {
                if (attr_answer == "") {
                    attr_answer =  $("problem_attr" + k + "_value").value;
                } else {
                    attr_answer =  attr_answer + ";|;" + $("problem_attr" + k + "_value").value;
                }
            }
        }
    } else if (parseFloat($("problem_correct_type").value) == 2) {
        var judge_attr_key = document.getElementsByName("attr_key");
        for (var l=0; l<judge_attr_key.length; l++) {
            if (judge_attr_key[l].checked == true) {
                attr_answer =  judge_attr_key[l].value;
            }
        }
    } else {
        attr_answer = $("problem_answer").value;
    }
    hash_str += ",|,answer=>" +  attr_answer + "";
    hash_str += ",|,attr_value=>"+ attr_value +"";

    if ($("problem_score") != null && $("problem_score").value != '') {
        hash_str += ",|,score=>"+  $("problem_score").value +"";
    }
    if ($("problem_analysis") != null && $("problem_analysis").value != "") {
        hash_str += ",|,analysis=>"+  $("problem_analysis").value +"";
    }
    if ($("tag") != null && $("tag").value != "") {
        hash_str += ",|,tag=>"+  $("tag").value +"";
    }
    hash_str += "}||";
    var parent = $("real_single_question_" + block_id);
    var div_length = parent.childNodes.length + 1;
    var div = document.createElement("div");
    div.innerHTML = "<div id='question_'"+ div_length +">" + $("problem_description").value + "</div><div>" + attr_value.split(";|;") +"</div>";
    div.innerHTML += "<div style='float:right;'><a herf='#'>删除</a></div><div class='clear'></div>";
    parent.appendChild(div);
    $("remote_que_div_" + block_id).innerHTML = "";
    $("choose_coll_que_link_" + block_id).style.display = "block";
    $("single_question_" + block_id).value += hash_str;
}

//修改综合题小题
function generate_edit_questions(problem_id) {
    var hash_str = "";
    var ids_str = $("all_question_ids_" + problem_id).value;
    var question_ids = ids_str.replace("[", "").replace("]", "").replace(/ /g , "").split(",")
    for (var i=0; i<question_ids.length; i++) {
        
        var attr_value = "";
        var attr_answer ="";
        var question_div = $("remote_question_" + question_ids[i]);
        if (question_div != null && $("make_edit_" + question_ids[i]).value == "1") {
            var inputs = question_div.getElementsByTagName("input");
            hash_str += "{1=>1,|,question_id=>" + question_ids[i];
            if (inputs != null && inputs[0] != null) {
                var attr = parseFloat(inputs[1].value);
                if (parseFloat(inputs[0].value) == 0) {                    
                    for (var k=2; k<inputs.length; k++) {
                        if (attr > 0) {
                            for (var m=0; m<attr; m++) {
                                if (inputs[k].id == "problem_attr_key_" + m) {
                                    attr_value += inputs[k+1].value + ";|;";
                                    if (inputs[k].checked == true) {
                                        attr_answer = inputs[k+1].value;

                                    }
                                }                                                      
                            } 
                        }
                        if (inputs[k].name == "problem[score]") {
                            hash_str += ",|,score=>"+  inputs[k].value +"";
                        }
                    }
                } else if (parseFloat(inputs[0].value) == 1) {
                    for (var l=2; l<inputs.length; l++) {
                        if (attr > 0) {
                            for (var n=0; n<attr; n++) {
                                if (inputs[l].id == "problem_attr_key_" + n) {
                                    attr_value += inputs[l+1].value + ";|;";
                                    if (inputs[l].checked == true) {
                                        if (attr_answer == "") {
                                            attr_answer =  inputs[l+1].value;
                                        } else {
                                            attr_answer =  attr_answer + ";|;" + inputs[l+1].value;
                                        }
                                    }
                                }
                            }
                        }
                        if (inputs[l].name == "problem[score]") {
                            hash_str += ",|,score=>"+  inputs[l].value +"";
                        }
                    }

                } else if (parseFloat(inputs[0].value) == 2) {
                    if (inputs[2].name == "attr_key" && inputs[2].checked == true) {
                        attr_answer = inputs[2].value;
                    } else if (inputs[3].name == "attr_key" && inputs[3].checked == true) {
                        attr_answer = inputs[3].value;
                    }
                    if (inputs[4].name == "problem[score]") {
                        hash_str += ",|,score=>"+  inputs[4].value +"";
                    }
                } else {
                    if (inputs[2].name == "problem[score]") {
                        hash_str += ",|,score=>"+  inputs[2].value +"";
                    }
                }
                if (attr_answer != "") {
                    hash_str += ",|,answer=>" +  attr_answer + "";
                }
                hash_str += ",|,attr_value=>"+ attr_value +"";

                var textarea = question_div.getElementsByTagName("textarea");
                if (textarea != null) {
                    for (var j=0; j<textarea.length; j++) {
                        if (textarea[j].name == "problem[description]" && textarea[j].value != "") {
                            hash_str += ",|,diescription=>"+  textarea[j].value + "";
                        } else if (textarea[j].name == "problem[answer]" && textarea[j].value != "") {
                            hash_str += ",|,answer=>" +  textarea[j].value + "";
                        } else if (textarea[j].name == "problem[analysis]" && textarea[j].value != "") {
                            hash_str += ",|,analysis=>" +  textarea[j].value + "";
                        }
                    }
                }
                hash_str += "}||";
            }           
        }   
    }
    $("edit_coll_question_" + problem_id).value = hash_str;
    $("edit_form_" + problem_id).submit();
}

//取消添加小题
function cancel_question(block_id) {
    $("remote_que_div_" + block_id).innerHTML = "";
    $("choose_coll_que_" + block_id).style.display = "none";
    $("choose_coll_que_link_" + block_id).style.display = "block";
}

function choose_question_type(id){

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
        document.getElementById("create_question_"+close_create_question_id).style.display="none";
        document.getElementById("mavin_question_"+close_create_question_id).style.display="none";
        close_create_question_id = 0;
    }
    $("choose_que_type_div_" + id).style.display = "block";
}

//取消添加试题选择题目类型
function cancel_choose_que_type(block_id) {
    $("choose_que_type_div_" + block_id).style.display = "none";
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

function show_choose_coll_que(block_id) {
    $("choose_coll_que_" + block_id).style.display = "block";
    $("choose_coll_que_link_" + block_id).style.display = "none";
}

//删除选项
function delete_attr(attr_id) {

}

//编辑综合题的题点
function edit_question(question_id, paper_id, xpath) {
    $("make_edit_" + question_id).value = "1";
    new Ajax.Updater("remote_question_" + question_id, "/questions/" + question_id + "/edit_question",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'paper_id=' + paper_id + '&xpath=' + xpath + '&authenticity_token='
        + encodeURIComponent('Q3CnqJgIgZEqWnlCyD902sexHwkF7phBA8hPYM1Tqxc=')
    });
    return false;
}

//专家创建题目
function mavin_create_problem(block_id) {
    if ($("mavin_question_" + block_id).style.display == "none") {
        $("mavin_question_" + block_id).style.display = "block";
    } else {
        $("mavin_question_" + block_id).style.display = "none";
    }   
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




