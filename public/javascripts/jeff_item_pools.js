
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


function item_pools_mavin_question(){
    $("choose_type").style.display = "none";
     new Ajax.Updater("mavin_question","/item_pools/ajax_item_pools_mavin_problem",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
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
function item_pools_colligation_question_type(q_type) {
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
    }
    else {
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
    if(problem_title.length == 0 || checkspace(text_source)){
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
            if(document.getElementById("problem_attr_key_"+index)!=null){
                if(document.getElementById("problem_attr_key_"+index).checked){
                    checked_num++;
                }
            }
        }
        if (checked_num==0){
            alert("请设置正确答案。");
            return false;
        }
    }
}

function ajax_item_pools_problem_info(id){
    new Ajax.Updater("show_div" , "/item_pools/ajax_item_pools_problem_info",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'id='+ id +'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs='        )
    });
    return false;
}

function ajax_item_pools_edit_problem(id){
    new Ajax.Updater("edit_div" , "/item_pools/ajax_item_pools_edit_problem",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'id='+ id +'&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs='        )
    });
    return false;
}

//编辑综合题的题点
function ajax_item_pools_edit_question(question_id) {
    $("make_edit_" + question_id).value = "1";
    new Ajax.Updater("remote_question_" + question_id, "/item_pools/ajax_item_pools_edit_question",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters: 'question_id='+question_id+'&authenticity_token='
        + encodeURIComponent('Q3CnqJgIgZEqWnlCyD902sexHwkF7phBA8hPYM1Tqxc=')
    });
    return false;
}

//修改综合题小题
function item_pools_generate_edit_questions(problem_id, problem_type) {
    
    if(item_pools_edit_problem_validate(problem_id)==false){
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
            if (question_div != null && $("make_edit_" + question_ids[i]).value == "1") {
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
                    } else if (parseFloat(inputs[0].value) == 1) {
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
                            }else if (inputs[l].name == "tag" && inputs[l].value != "") {
                                hash_str += ",|,tag=>" +  inputs[l].value + "";
                            }
                        }
                        attr_array_sort=attr_array.sort();
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
                        if (inputs[4].name == "tag" && inputs[4].value != "") {
                            hash_str += ",|,tag=>" +  inputs[4].value + "";
                        }
                    } else {
                        if (inputs[2].name == "tag" && inputs[2].value != "") {
                            hash_str += ",|,tag=>" +  inputs[2].value + "";
                        }
                    }
                    if (attr_answer != "") {
                        hash_str += ",|,answer=>" +  attr_answer + "";
                    }
                    hash_str += ",|,attr_value=>"+ attr_value +"";
                    var textarea = question_div.getElementsByTagName("textarea");
                    if (textarea != null) {
                        for (var j=0; j<textarea.length; j++) {
                            if (textarea[j].name == "problem[description]" && textarea[j].value==""){
                                alert("题目描述不能为空。");
                                return false;
                            }
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

//验证 编辑题目
function item_pools_edit_problem_validate(problem_id){

    if($("edit_title_"+problem_id).value!=null){
        var problem_title = $("edit_title_"+problem_id).value.replace(/<br \/>/g,"");
        var text_source = problem_title.replace(/^\s+/, "").replace(/ \s+$/, "");
        if(problem_title=="" || checkspace(text_source)){
            alert("题面不能为空。");
            return false;
        }
    }

    var answer_array=[];
    if (document.getElementById("problem_attr_sum").value!=null){
        for(var i=1;i<=parseInt(document.getElementById("problem_attr_sum").value);i++){     //验证 选项不能为空
            if(document.getElementById("problem_attr"+i+"_value")!=null){
                var attr_value = document.getElementById("problem_attr"+i+"_value").value;
                answer_array.push(attr_value);
                if (attr_value==""){
                    alert("选项不能为空。");
                    return false;
                }
            }
        }
    }
    if(document.getElementById("problem_answer")!=null){           //验证答案不能为空
        var problem_answer = document.getElementById("problem_answer").value;
        if (problem_answer==""){
            alert("答案不能为空。");
            return false;
        }
    }
    if(document.getElementById("problem_attr_key_1")!=null){
        var checked_num = 0;                               //验证是否选择正确答案,单选,多选都可用
        for(i=0;i<parseInt(document.getElementById("problem_attr_sum").value);i++){
            if(document.getElementById("problem_attr_key_"+(i+1))!=null && document.getElementById("problem_attr_key_"+(i+1)).checked){
                checked_num++;
            }
        }
        if (checked_num==0){
            alert("请设置正确选项。");
            return false;
        }
    }
}

//显示富文本编辑器
function item_pools_add_area(content_id, button) {
    var area = new nicEditor({
        fullPanel : true
    }).panelInstance(content_id);
    button.value = "普通文本";
    button.onclick = function onclick(event) {
        javascript:remove_area(area, content_id, button);
    };
}

//取消富文本编辑器
function item_pools_remove_area(area,content_id, button) {
    area.removeInstance(content_id);
    button.value = "富文本";
    button.onclick = function onclick(event) {
        javascript:add_area(content_id, button);
    };
}

//验证专家新建题目
function item_pools_check_mavin_problem() {
    $("span").innerHTML = "";
    var mavin_title = $("mavin_problem_title").value;
    if (mavin_title != null && checkspace(mavin_title)) {
        $("span").innerHTML = "<font color='red'>请您填写好题目后再保存。</font>";
        return false;
    }
    if (!mavin_title.include("[[") && !mavin_title.include("{{")) {
        $("span").innerHTML = "<font color='red'>请您设置题点。</font>";
        return false;
    }
    if ((mavin_title.include("[[") && !mavin_title.include("]]"))||(mavin_title.include("{{") && !mavin_title.include("}}"))) {
        $("span").innerHTML = "<font color='red'>您的提点格式不正确，提点格式为[[提点内容]]。</font>";
        return false;
    }
    if (!mavin_title.include("[(")) {
        $("span").innerHTML = "<font color='red'>请您设置分值。</font>";
        return false;
    }
    if (mavin_title.include("[(") && !mavin_title.include(")]")) {
        $("span").innerHTML = "<font color='red'>您的分值格式不正确，提点格式为[(分数)]。</font>";
        return false;
    }
    if (!mavin_title.include("[{")) {
        $("span").innerHTML = "<font color='red'>请您设置解析。</font>";
        return false;
    }
    if (mavin_title.include("[{") && !mavin_title.include("}]")) {
        $("span").innerHTML = "<font color='red'>您的解析格式不正确，提点格式为[{解析}]。</font>";
        return false;
    }
    sumbit_form("problem_form", "problem_submit", "spinner");
}