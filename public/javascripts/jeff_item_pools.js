

function item_pools_create_question(){
    var types = document.getElementsByName("type_radio");
    for (var i=0; i<types.length; i++) {
        if (types[i].checked == true) {
            var problem_type = types[i].value;
        }
    }
    $("choose_type").style.display = "none";
    $("create_question").style.display = "block";
    item_pools_get_question_type(problem_type);
}

function item_pools_show_choose_coll_que() {
    $("choose_coll_que").style.display = "block";
    $("choose_coll_que_link").style.display = "none";
}

function item_pools_get_question_type(type) {
    
    new Ajax.Updater("new_question","/item_pools/choose_type",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'type='+type+'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

//将选中的题目的类型提交给新创建试题块的type隐藏域
function item_pools_colligation_question_type(question_type) {
    var problem_type = 4;
    var question_type = "";
    var types = document.getElementsByName("colligation_type_radio");
    for (var i=0; i<types.length; i++) {
        if (types[i].checked == true) {
            question_type = types[i].value;
        }
    }
    $("choose_coll_que").style.display = "none";
    $("choose_coll_que_link").style.display = "none";
    new Ajax.Updater("remote_que_div" , "/item_pools/colligation_choose_type",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'question_type='+ question_type +'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}

function item_pools_colligation_new_question() {
    if(item_pools_colligation_question_validate()==false){
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
    } else if (parseFloat($("problem_correct_type").value) == 1) {
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
    var parent = $("real_single_question");
    var div_length = parent.childNodes.length + 1;
    var div = document.createElement("div");
    div.innerHTML = "<div id='question_'"+ div_length +">" + $("problem_description").value + "</div><div>" + attr_value.split(";|;") +"</div>";
    div.innerHTML += "<div style='float:right;'><a herf='#'>删除</a></div><div class='clear'></div>";
    parent.appendChild(div);
    $("remote_que_div").innerHTML = "";
    $("choose_coll_que_link").style.display = "block";
    $("single_question").value += hash_str;
}

//验证添加综合题的小题
function item_pools_colligation_question_validate(){
    if ($("problem_description")!= null && $("problem_description").value == "") {
        alert("小题描述不能为空。");
        return false;
    }
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


//验证 新建题目
function item_pools_new_problem_validate(){
    var problem_title = $("problem_title").value.replace(/<br \/>/g,"");
    var text_source = problem_title.replace(/^\s+/, "").replace(/ \s+$/, "");
    if(problem_title == null  || problem_title.length == 0 || checkspace(text_source)){
        alert("题面不能为空。");
        return false;
    }
    var check_chose=0;
    if($("problem_attr_sum")!=null){
        for(var i=1;i<=parseInt($("problem_attr_sum").value);i++){
            if($("problem_attr"+i+"_value")!=null){
                check_chose++;
            }
        }
    } //如果check_chose大于0，则说明是一道选择题。即存在id如problem_attr1_value的表单元素。

    if(check_chose!=0){
        var answer_array=new Array;
        for(var i=1;i<=parseInt(document.getElementById("problem_attr_sum").value);i++){     //验证 选项不能为空
            if(document.getElementById("problem_attr"+i+"_value")!=null){
                var attr_value = document.getElementById("problem_attr"+i+"_value").value;
                answer_array.push(attr_value);
                if (attr_value==""||checkspace(attr_value)){
                    alert("选项不能为空。");
                    return false;
                }
            }
        }
        var answer_array_sort=answer_array.sort();
        for(var i=0;i<answer_array.length;i++){
            if (answer_array_sort[i]==answer_array_sort[i+1]){
                alert("选项内容重复："+answer_array_sort[i]);
                return false;
            }
        }
    }
    if(document.getElementById("problem_answer")!=null){           //验证答案不能为空
        var problem_answer = document.getElementById("problem_answer").value;
        if (problem_answer==""||checkspace(problem_answer)){
            alert("答案不能为空。");
            return false;
        }
    }
    //验证是否选择正确答案,单选,多选都可用
    if(check_chose!=0){
        var checked_num = 0;
        for(i=0;i<parseInt(document.getElementById("problem_attr_sum").value);i++){
            var index=i+1;
            if(document.getElementById("problem_attr_key_"+index).checked){
                checked_num++;
            }
        }
        if (checked_num==0){
            alert("请设置正确答案。");
            return false;
        }
    }
}
