close_question_info_id = 0
close_create_question_id = 0
close_edit_problem_id = 0
close_edit_block_id = 0
close_mavin_question_id = 0
close_state_question_id = 0
close_edit_state_id = 0

//if (window.onbeforeunload == undefined) {
//    window.onbeforeunload=function() {
//        return "您还未保存试卷，确定要离开当前页面么？";
//    }
//}
function save_paper_js(paper_id) {
    $("spinner_for_submit").show();
    $("paper_js_button").hide();
    window.location.href="/papers/"+ paper_id +"/create_all_paper";
}

//整体处理各个模块div的显示和关闭
function manage_div(open_div_id, div_sup_name) {
    if (close_edit_block_id != 0  && div_sup_name != "edit_block") {   //关闭模块编辑框
        document.getElementById("edit_block_" + close_edit_block_id).style.display = "none";
        close_edit_block_id = 0;
    }
    if (close_question_info_id != 0  && div_sup_name != "question_info") {   //关闭查看框
        document.getElementById("question_info_" + close_question_info_id).style.display = "none";
        close_question_info_id = 0;
    }
    if (close_edit_problem_id != 0 &&  div_sup_name != "edit_problem") {   //关闭编辑框
        document.getElementById("edit_problem_"+close_edit_problem_id).innerHTML="";
        close_edit_problem_id = 0;
    }

    if(close_create_question_id != 0 &&  div_sup_name != "create_question"){
        document.getElementById("create_question_"+close_create_question_id).innerHTML="";
        close_create_question_id = 0;
    }

    if(close_mavin_question_id != 0  && div_sup_name != "mavin_question"){
        document.getElementById("mavin_question_"+close_mavin_question_id).innerHTML="";
        close_mavin_question_id = 0;
    }

    if(close_state_question_id != 0  && div_sup_name != "state_question"){
        document.getElementById("state_question_"+close_state_question_id).innerHTML="";
        close_state_question_id = 0;
    }
    if(close_edit_state_id != 0  && div_sup_name != "edit_state"){
        document.getElementById("edit_state_descritpion_"+close_edit_state_id).innerHTML="";
        close_edit_state_id = 0;
    }
    
    if (div_sup_name == "new_module") {
        if(document.getElementById("new_module").style.display=="block"){
            document.getElementById("new_module").style.display="none";
        }else{
            document.getElementById("new_module").style.display="block";
        }
    }
}

//创建问题，关闭其它正在打开的div的框
function create_question(id, paper_id){
    manage_div(id, "create_question");
    if(close_create_question_id != 0 && close_create_question_id != id){
        document.getElementById("create_question_"+close_create_question_id).innerHTML = "";
    }
    if (document.getElementById("create_question_"+id).innerHTML == "") {
        load_create_problem(id, paper_id, "create");
    }
    close_create_question_id = id;

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
    }
    else {
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
var question_types = {
    0:"单选题",
    1:"多选题",
    2:"判断题",
    3:"填空题",
    5:"简答题",
    6:"完形填空题"
}
var small_questions = [];
function new_question(block_id) {
    if(question_validate()==false){
        return false;
    }
    var hash_str = "{1=>1";
    if ($("problem_description")!= null && $("problem_description").value != "") {
        hash_str += ",|,diescription=>"+  $("problem_description").value + "";
    }
    hash_str += ",|,correct_type=>"+  $("problem_correct_type").value + "";
    if  ($("problem_attr_sum") != null && $("problem_attr_sum").value != "") {
        hash_str += ",|,problem_attr_sum=>"+  $("problem_attr_sum").value + "";
    }
    var attr_value = "";
    var attr_answer ="";
    if (parseFloat($("problem_correct_type").value) == 0) {
        for (var i=1; i<=parseFloat($("problem_attr_sum").value); i++) {
            if($("problem_attr" + i + "_value")!=null){
                attr_value += $("problem_attr" + i + "_value").value;
                attr_value += ";|;"
                var attr_key = document.getElementsByName("attr_key");
                if (attr_key != null) {
                    for (var j=0; j<attr_key.length; j++) {
                        if (attr_key[j].checked == true) {
                            var answer_id = attr_key[j].value;
                            attr_answer = $("problem_attr" + answer_id + "_value").value;
                        }
                    }
                }
            }
        }
    } else if (parseFloat($("problem_correct_type").value) == 1 || parseFloat($("problem_correct_type").value) == 6) {
        for (var k=1; k<=parseFloat($("problem_attr_sum").value); k++) {
            if($("problem_attr" + k + "_value")!=null){
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
    div.id = "new_small_question_"+div_length;
    $("single_question_" + block_id).value += hash_str;
    div.innerHTML = "<div id='question_"+ div_length +"'>" + $("problem_description").value + "</div><div>"+ question_types[parseFloat($("problem_correct_type").value)]+"</div><div>" + attr_value.split(";|;") +"</div><div style='float:right;'><a herf='javascript:void(0);' onclick='javascript:delete_new_question("+block_id+",this,"+(div_length-1)+");'>删除</a></div><div class='clear'></div>";
    parent.appendChild(div);
    $("remote_que_div_" + block_id).innerHTML = "";
    $("choose_coll_que_link_" + block_id).style.display = "block"; 
}

//删除新建的综合题小题
function delete_new_question(block_id,element,index) {
    $('real_single_question_'+block_id).removeChild(element.parentNode.parentNode);
    var array = $("single_question_" + block_id).value.split("||");
    array.splice(index,1,"");
    $("single_question_" + block_id).value = array.join("||");
}


//验证添加综合题的小题
function question_validate(){
    //    if ($("problem_description")!= null && $("problem_description").value == "") {
    //        alert("小题描述不能为空。");
    //        return false;
    //    }
    if (parseFloat($("problem_correct_type").value) == 0 ||parseFloat($("problem_correct_type").value) == 1){
        var answer_array=new Array;
        for (var i=1; i<=parseFloat($("problem_attr_sum").value); i++) {
            if ($("problem_attr" + i + "_value")!=null && $("problem_attr" + i + "_value").value=="") {
                alert("选项不能为空。");
                return false;
            }
            if($("problem_attr" + i + "_value")!=null){
                answer_array.push($("problem_attr" + i + "_value").value);
            }
        }
        var answer_array_sort=answer_array.sort();
        for(var i=0;i<answer_array.length;i++){
            if (answer_array_sort[i]==answer_array_sort[i+1]){
                alert("选项不能重复 ： "+answer_array_sort[i]);
                return false;
            }
        }

        if(document.getElementsByName("attr_key").length!=0) {
            var checked_num=0;
            var attr_key = document.getElementsByName("attr_key");
            var attr_sum = document.getElementById("problem_attr_sum").value;
            for (var j=1; j<=attr_sum; j++) {
                if (attr_key[j-1]!=null && attr_key[j-1].checked == true) {
                    checked_num++;
                }
            }
            if (checked_num==0){
                alert("请设置正确选项。");
                return false;
            }
        }     //单选题，验证设置选项

        if(parseFloat($("problem_correct_type").value) == 1) {
            var checked_num=0;
            for (var j=1; j<=parseFloat($("problem_attr_sum").value); j++) {
                var attr_key = document.getElementById("problem_attr_key_"+j);
                if (attr_key!=null && attr_key.value == j && attr_key.checked == true) {
                    checked_num++;
                }
            }
            if(checked_num==0){
                alert("请设置正确选项。");
                return false;
            }
        }     //多选题，验证设置选项
    }

    
    if(parseFloat($("problem_correct_type").value) == 3||parseFloat($("problem_correct_type").value) == 5){
        var problem_answer = $("problem_answer").value;
        if(problem_answer==""){
            alert("答案不能为空。");
            return false;
        }
    }   //验证答案不能为空
}   

//整理新建综合题小题，验证通过后提交表单
function post_form_small_question(type){
    if(type==null||type==""){
        alert("操作有误，请选择小题类型");
        return false;
    }
    return question_validate();
}

//修改综合题小题
function generate_edit_questions(problem_id, problem_type) {

    if(edit_problem_validate(problem_id)==false){
        return false;
    }
    if (parseFloat(problem_type) == 4) {
        var hash_str = "";
        var ids_str = $("all_question_ids_" + problem_id).value;
        var question_ids = ids_str.replace("[", "").replace("]", "").replace(/ /g , "").split(",");
        for (var i=0; i<question_ids.length; i++) {
            var attr_value = "";
            var attr_answer ="";
            var question_div = $("remote_question_" + question_ids[i]);
            if (question_div != null && $("question_list_" + question_ids[i])!=null &&$("make_edit_" + question_ids[i]).value == "1") {
                var inputs = question_div.getElementsByTagName("input");
                hash_str += "{1=>1,|,question_id=>" + question_ids[i];
                if (inputs != null && inputs[0] != null) {
                    var attr = parseFloat(inputs[1].value);
                    if (parseFloat(inputs[0].value) == 0) {
                        var attr_array = [];
                        for (var k=2; k<inputs.length; k++) {
                            if (attr > 0) {
                                for (var m=1; m<=attr; m++) {
                                    if (inputs[k].id == "problem_attr_key_" + m) {
                                        if(inputs[k+1].value==""){
                                            alert("选项不能为空！");
                                            return false;
                                        }
                                        attr_array.push(inputs[k+1].value);
                                        attr_value += inputs[k+1].value + ";|;";
                                        if (inputs[k].checked == true) {
                                            attr_answer = inputs[k+1].value;
                                        }
                                    }
                                }
                            }
                            if (inputs[k].name == "problem[score]") {
                                hash_str += ",|,score=>"+  inputs[k].value +"";
                            }else if (inputs[k].name == "tag" && inputs[k].value != "") {
                                hash_str += ",|,tag=>" +  inputs[k].value + "";
                            }
                        }
                    } else if (parseFloat(inputs[0].value) == 1 || parseFloat(inputs[0].value) == 6) {
                        var attr_array = [];
                        var answer_sum = 0;
                        for (var l=2; l<inputs.length; l++) {
                            if (attr > 0) {
                                for (var n=1; n<=attr; n++) {
                                    if (inputs[l].id == "problem_attr_key_" + n) {
                                        if(inputs[l+1].value==""){
                                            alert("选项不能为空！");
                                            return false;
                                        }
                                        attr_array.push(inputs[l+1].value);
                                        attr_value += inputs[l+1].value + ";|;";
                                        if (inputs[l].checked == true) {
                                            if (attr_answer == "") {
                                                attr_answer =  inputs[l+1].value;
                                            } else {
                                                attr_answer =  attr_answer + ";|;" + inputs[l+1].value;
                                            }
                                            answer_sum++;
                                        }
                                    }
                                }
                            }
                            if (inputs[l].name == "problem[score]") {
                                hash_str += ",|,score=>"+  inputs[l].value +"";
                            } else if (inputs[l].name == "tag" && inputs[l].value != "") {
                                hash_str += ",|,tag=>" +  inputs[l].value + "";
                            }
                        }
                        var attr_array_sort=attr_array.sort();
                        for(var q=0;q<attr_array.length;q++){
                            if (attr_array_sort[q]==attr_array_sort[q+1]){
                                alert("选项内容重复："+attr_array_sort[q]);
                                return false;
                            }
                        }
                        if(answer_sum==0){
                            alert("请设置正确答案。");
                            return false;
                        }
                    } else if (parseFloat(inputs[0].value) == 2) {
                        if (inputs[2].id == "problem_attr_key" && inputs[2].checked == true) {
                            attr_answer = inputs[2].value;
                        } else if (inputs[3].id == "problem_attr_key" && inputs[3].checked == true) {
                            attr_answer = inputs[3].value;
                        }
                        if (inputs[4].name == "problem[score]") {
                            hash_str += ",|,score=>"+  inputs[4].value +"";
                        }
                        if (inputs[5].name == "tag" && inputs[5].value != "") {
                            hash_str += ",|,tag=>" +  inputs[5].value + "";
                        }
                    } else {
                        if (inputs[2].name == "problem[score]") {
                            hash_str += ",|,score=>"+  inputs[2].value +"";
                        }
                        if (inputs[3].name == "tag" && inputs[3].value != "") {
                            hash_str += ",|,tag=>" +  inputs[3].value + "";
                        }
                    }
                    if (attr_answer != "") {
                        hash_str += ",|,answer=>" +  attr_answer + "";
                    }

                    hash_str += ",|,attr_value=>"+ attr_value +"";
                    var textarea = question_div.getElementsByTagName("textarea");
                    if (textarea != null) {
                        for (var j=0; j<textarea.length; j++) {
                            if (textarea[j].id == "problem_answer" && textarea[j].value==""){
                                alert("答案不能为空。");
                                return false;
                            }
                            if (textarea[j].name == "problem[description]" && textarea[j].value != "") {
                                hash_str += ",|,diescription=>"+  textarea[j].value + "";
                            } else if (textarea[j].id == "problem_answer" && textarea[j].value != "") {
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
    }
    $("edit_form_" + problem_id).submit();
}


//取消添加小题
function cancel_question(block_id) {
    $("remote_que_div_" + block_id).innerHTML = "";
    $("choose_coll_que_" + block_id).style.display = "none";
    $("choose_coll_que_link_" + block_id).style.display = "block";
}

//显示富文本编辑器
function add_area(content_id, button) {
    var area = new nicEditor({
        fullPanel : true
    }).panelInstance(content_id);
    button.value = "普通文本";
    button.onclick = function onclick(event) {
        javascript:remove_area(area, content_id, button);
    };
}

function validate_blank(id){
    var description=$('mavin_problem_title_'+id).value;
    if (description==""||description.length==0){
        alert("请输入试题说明");
        return false;
    }
}

//取消富文本编辑器
function remove_area(area,content_id, button) {
    area.removeInstance(content_id);
    button.value = "富文本";
    button.onclick = function onclick(event) {
        javascript:add_area(content_id, button);
    };
}

//打开选择题型的div
function choose_question_type(id){
    manage_div(-1, "choose_question_type");
    $("choose_que_type_div_" + id).style.display = "block";
}

//取消添加试题选择题目类型
function cancel_choose_que_type(block_id) {
    $("choose_que_type_div_" + block_id).style.display = "none";
}

//修改试卷基本信息
function change_info(){
    manage_div(-1, "change_info");
    document.getElementById("paper_edit_info").style.display="block";
    document.getElementById("paper_show_info").style.display="none";
}

//新建模块
function new_module(){
    manage_div(-1, "new_module");
}

//显示题目
function question_info(id){
    manage_div(id, "question_info");
    if(close_question_info_id != 0 && close_question_info_id != id){
        document.getElementById("question_info_" + close_question_info_id).style.display = "none";
    }
    document.getElementById("question_info_" + id).style.display = "block";
    close_question_info_id = id;
}

//编辑题目
function edit_problem(id,block_id,paper_id){
    manage_div(id, "edit_problem");
    if(close_edit_problem_id != 0 && close_edit_problem_id != id){
        document.getElementById("edit_problem_"+close_edit_problem_id).innerHTML = "";
    }
    if (document.getElementById("edit_problem_"+id).innerHTML == "") {
        load_edit_problem(id,block_id,paper_id);
    }
    close_edit_problem_id = id;
}

//编辑模块描述
function edit_problem_state(block_id, paper_id, part_id){
    manage_div(part_id, "edit_state");
    if(close_edit_state_id != 0 && part_id != close_edit_state_id){
        document.getElementById("edit_state_descritpion_"+close_edit_state_id).innerHTML = "";
    }
    if (document.getElementById("edit_state_descritpion_"+ part_id).innerHTML == "") {
        load_problem_edit(block_id,paper_id,part_id);
    }
    close_edit_state_id = part_id;
}

function load_problem_edit(block_id,paper_id,part_id){
    new Ajax.Updater("edit_state_descritpion_" + part_id, "/problems/"+ part_id+"/load_edit_part",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters: 'block_id=' + block_id + '&paper_id=' + paper_id+
        '&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}


//载入修改题目面板
function load_edit_problem(problem_id,block_id,paper_id){
    new Ajax.Updater("edit_problem_" + problem_id, "/paper_blocks/load_edit_problem",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'problem_id=' + problem_id + '&block_id=' + block_id + '&paper_id=' + paper_id+
        '&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

//载入专家新建题目模板
function load_mavin_problem(block_id, paper_id) {
    manage_div(block_id, "mavin_question");
    if(close_mavin_question_id != 0 && close_mavin_question_id != block_id){
        document.getElementById("mavin_question_"+close_mavin_question_id).innerHTML = "";
    }

    if (document.getElementById("mavin_question_"+block_id).innerHTML == "") {
        load_create_problem(block_id, paper_id, 'mavin');
    }
    close_mavin_question_id = block_id;
    
}

//载入试题说明
function load_problem_state(block_id, paper_id) {
    manage_div(block_id, "state_question");
    if(close_state_question_id != 0 && close_state_question_id != block_id){
        document.getElementById("state_question_"+close_state_question_id).innerHTML = "";
    }
    if (document.getElementById("state_question_"+block_id).innerHTML == "") {
        load_create_problem(block_id, paper_id, 'state');
    }
    close_state_question_id = block_id;

}

//载入新建题目面板
function load_create_problem(block_id,paper_id, create_type) {
    new Ajax.Updater(create_type + "_question_" + block_id, "/paper_blocks/load_create_problem",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        onComplete:function(request){
            if (create_type == "create") {
                get_question_type(block_id, paper_id, null, "new_problem_");
            }
        },
        parameters:'block_id=' + block_id + '&paper_id=' + paper_id + '&type=' + create_type +
        '&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

function load_set_right(role_id){
    new Ajax.Updater("set_right_div", "/users/load_set_right",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'role_id=' + role_id +'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

function cancel_set_right(){
    $("set_right_div").innerHTML="";
    return false;
}

function load_edit_role(role_id){
    new Ajax.Updater("set_right_div", "/users/load_edit_role",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'role_id=' + role_id +'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

function load_set_role(user_id){
    new Ajax.Updater("set_role_div", "/users/load_set_role",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'user_id=' + user_id +'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

function cancel_set_role(){
    $("set_role_div").innerHTML="";
    return false;
}

function validate_role_name(){
    var role_name = document.getElementById("role_name_test");
    if (role_name!=null){
        if (role_name.value==""){
            alert("角色名不能为空");
            return false;
        }
    }
}

function validate_new_role_name(){
    var role_name2 = document.getElementById("new_role_name");
    if (role_name2!=null){
        if (role_name2.value==""){
            alert("角色名不能为空");
            return false;
        }
    }
}

function visible_add_role(){
    if($("add_role_div").style.display=="none")
        $("add_role_div").style.display="block";
    else
        $("add_role_div").style.display="none";
}


//编辑模块
function edit_block(id){
    manage_div(id, "edit_block");
    if(close_edit_block_id != 0 && close_edit_block_id != id){
        document.getElementById("edit_block_"+close_edit_block_id).style.display = "none";
    }
    document.getElementById("edit_block_"+id).style.display = "block";
    close_edit_block_id = id;
}

function show_choose_coll_que(block_id) {
    $("choose_coll_que_" + block_id).style.display = "block";
    $("choose_coll_que_link_" + block_id).style.display = "none";
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

function new_attr(type){
    if(type=="single_choose"){
        var attr_sum_element=document.getElementById("problem_attr_sum");
        var attr_sum=attr_sum_element.value;
        attr_sum++;
        var attrs =  document.getElementById("attrs");
        var tmpObj = document.createElement("div");
        tmpObj.setAttribute("class", "attr");
        var attribute_id="attr_"+attr_sum;
        tmpObj.setAttribute("id",attribute_id);
        var content = "<input type='radio' id='problem_attr_key_"+attr_sum+"' name='attr_key' value='"+attr_sum+"'/>";
        content += "<input type='text' name='attr"+attr_sum+"_value' id='problem_attr"+attr_sum+"_value' class='input_style' size='15' value='' />";
        content += "<a href='javascript:void(0);' onclick='javascript:delete_attr("+attr_sum+");'> 删除</a>";
        tmpObj.innerHTML=content;
        attrs.appendChild(tmpObj);
        attr_sum_element.setAttribute("value",attr_sum.toString());
    }
    if(type=="more_choose"){
        var attr_sum_element=document.getElementById("problem_attr_sum");
        var attr_sum=attr_sum_element.value;
        attr_sum++;
        var content = "<input type='checkbox' id='problem_attr_key_"+attr_sum+"' name='attr"+attr_sum+"_key' value='"+attr_sum+"'/>";
        content += "<input type='text' name='attr"+attr_sum+"_value' id='problem_attr"+attr_sum+"_value' class='input_style' size='15' value='' />";
        content += "<a href='javascript:void(0);' onclick='javascript:delete_attr("+attr_sum+");'> 删除</a>";
        var attrs =  document.getElementById("attrs");
        var tmpObj = document.createElement("div");
        tmpObj.setAttribute("class", "attr");
        var attribute_id="attr_"+attr_sum;
        tmpObj.setAttribute("id",attribute_id);
        tmpObj.innerHTML=content;
        attrs.appendChild(tmpObj);
        attr_sum_element.setAttribute("value",attr_sum.toString());
    }
}

//删除选项
function delete_attr(attr_id) {
    var attrs = document.getElementById("attr_"+attr_id);
    attrs.innerHTML="";

}

function new_attr_edit(type,question_id){
    if(type=="single_choose"){
        var attrs =  document.getElementById("attrs_"+question_id);
        var inputs = attrs.getElementsByTagName("input");
        var attr_sum_element=inputs[0];
        var attr_sum=attr_sum_element.value;
        attr_sum++;
        var content = "<input type='radio' id='problem_attr_key_"+attr_sum+"' name='attr_key"+question_id+"' value='"+attr_sum+"'/>";
        content += "<input type='text' name='attr"+attr_sum+"_value"+question_id+"' id='problem_attr"+attr_sum+"_value' class='input_style' size='15' value='' />";
        content += "<a href='javascript:void(0);' onclick='javascript:delete_attr_edit("+attr_sum+","+question_id+");'> 删除</a>";
        var tmpObj = document.createElement("div");
        tmpObj.setAttribute("class", "attr");
        var attribute_id="attr_"+attr_sum+"_"+question_id;
        tmpObj.setAttribute("id",attribute_id);
        tmpObj.innerHTML=content;
        attrs.appendChild(tmpObj);
        attr_sum_element.setAttribute("value",attr_sum.toString());
    }
    if(type=="more_choose"){
        var attrs =  document.getElementById("attrs_"+question_id);
        var inputs = attrs.getElementsByTagName("input");
        var attr_sum_element=inputs[0];
        var attr_sum=attr_sum_element.value;
        attr_sum++;
        var content = "<input type='checkbox' id='problem_attr_key_"+attr_sum+"' name='attr"+attr_sum+"_key"+question_id+"' value='"+attr_sum+"'/>";
        content += "<input type='text' name='attr"+attr_sum+"_value"+question_id+"' id='problem_attr"+attr_sum+"_value' class='input_style' size='15' value='' />";
        content += "<a href='javascript:void(0);' onclick='javascript:delete_attr_edit("+attr_sum+","+question_id+");'> 删除</a>";


        var tmpObj = document.createElement("div");
        tmpObj.setAttribute("class", "attr");
        var attribute_id="attr_"+attr_sum+"_"+question_id;
        tmpObj.setAttribute("id",attribute_id);
        tmpObj.innerHTML=content;
        attrs.appendChild(tmpObj);
        attr_sum_element.setAttribute("value",attr_sum.toString());
    }
}

function delete_attr_edit(attr_id,question_id){
    var attrs = document.getElementById("attr_"+attr_id+"_"+question_id);
    attrs.innerHTML="";
}

function delete_question(question_id) {
    $("question_list_" + question_id).innerHTML = "";
}

//
//function audio_play(id){
//    if(getCookie("audio_"+id)==null){
//        setCookie(("audio_"+id),0)
//    }
//    if(get_canplay_time()==0||$("audio_control_"+id).title=="停止"||getCookie("audio_"+id)<get_canplay_time()){  //设置播放次数
//        if($("audio_"+id).paused){
//            $("audio_"+id).load();
//            $("audio_"+id).play();
//            $("audio_control_"+id).src="/images/paper/zanting_icon.png";
//            if(id!="x"){
//                setCookie(("audio_"+id),parseInt(getCookie("audio_"+id))+1);
//                $("audio_control_"+id).title="停止";
//                $("audio_control_"+id).src="/images/paper/zanting_icon.png";
//            }
//        }
//        else{
//            if(get_canplay_time()==0){
//                setCookie(("audio_"+id),0);
//                $("audio_"+id).pause();
//                $("audio_control_"+id).title="播放";
//                $("audio_control_"+id).src="/images/paper/play_icon.png";
//            }else{
//                if(confirm("该音频有播放次数限制，\"停止\"播放也会记录播放次数。这可能导致你的损失。你确定要停止么？\n 当前播放次数/总次数 ："+getCookie("audio_"+id)+"/"+get_canplay_time())){
//                    $("audio_"+id).pause();
//                    $("audio_control_"+id).title="播放";
//                    $("audio_control_"+id).src="/images/paper/play_icon.png";
//                }
//            }
//        }
//    }
//    else{
//        $("audio_"+id).pause();
//        $("audio_control_"+id).title="播放";
//        $("audio_control_"+id).src="/images/paper/play_icon.png";
//        alert("该录音已经播放了"+get_canplay_time()+"次！不能再播放！");
//    }
//}
//

// jplayer播放器控制
function audio_play(id,src){
    var this_src = src.replace("~http://back_server_path~",back_server_path);
    jQuery("#jquery_jplayer").jPlayer("setMedia", {
        mp3: this_src
    });
    jQuery("#jquery_jplayer").jPlayer("play");
}

function audio_element(problem_title, flag_id) {
    var final_title = generate_audio_element(flag_id);
    document.write(final_title);
    generate_jplayer(problem_title, flag_id);
}

//new_step_two 删除题目
function delete_problem_form(form_id){
    if(confirm("你确定要删除么？")){
        document.getElementById(form_id).submit();
    }
}


function generate_audio_element(flag_id) {
    var final_title = "<div id='jquery_jplayer_"+flag_id+"' class='jp-jplayer'></div>"
    + "<div id='jp_container_1' class='jp-audio'><div class='jp-type-single'><div class='jp-gui jp-interface'>"
    + "<ul class='jp-controls'><li><a href='javascript:;' class='jp-play' tabindex='1'>play</a></li>"
    + "<li><a href='javascript:;' class='jp-pause' tabindex='1'>pause</a></li>"
    + "<li><a href='javascript:;' class='jp-stop' tabindex='1'>stop</a></li>"
    + "<li><a href='javascript:;' class='jp-mute' tabindex='1' title='mute'>mute</a></li>"
    + "<li><a href='javascript:;' class='jp-unmute' tabindex='1' title='unmute'>unmute</a></li>"
    + "<li><a href='javascript:;' class='jp-volume-max' tabindex='1' title='max volume'>max volume</a></li></ul>"
    + "<div class='jp-progress'><div class='jp-seek-bar'><div class='jp-play-bar'></div></div></div>"
    + "<div class='jp-volume-bar'><div class='jp-volume-bar-value'></div></div>"
    + "<div class='jp-time-holder'><div class='jp-current-time'></div><div class='jp-duration'></div></div></div></div></div>";
    return final_title;
}

function generate_jplayer(problem_title, flag_id) {
    (function(){
        jQuery("#jquery_jplayer_"+flag_id).jPlayer({
            ready: function (event) {
                jQuery(this).jPlayer("setMedia", {
                    mp3:""+problem_title
                });
            },
            swfPath: "/javascripts/jplayer",
            supplied: "mp3",
            wmode: "window"
        });
    })(jQuery)
}

function add_small_question(problem_id,block_id,paper_id,problem_index){
    manage_div(null, ""); //关闭所有其它面板
    document.getElementById("problem_correct_type").value="";
    document.getElementById("small_question_main_div").innerHTML="";
    document.getElementById('new_small_question_paper_id').value=paper_id;
    document.getElementById('new_small_question_block_id').value=block_id;
    document.getElementById('new_small_question_problem_id').value=problem_id;
    document.getElementById('new_small_question_title').innerHTML=" ("+problem_index+") "+document.getElementById("mark_problem_title_"+problem_id).innerHTML;
    document.getElementById('new_small_question_div').style.display='block';
}

function choose_small_question_type(question_type,partial){
    document.getElementById("problem_correct_type").value=question_type;
    new Ajax.Updater("small_question_main_div", "/questions/ajax_small_question_type",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'partial=' + partial + '&authenticity_token='
        + encodeURIComponent('Q3CnqJgIgZEqWnlCyD902sexHwkF7phBA8hPYM1Tqxc=')
    });
    return false;
}
