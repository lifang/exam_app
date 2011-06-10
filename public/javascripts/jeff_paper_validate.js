
//验证  修改试卷基本信息
function edit_paper_info(){
    var paper_title=document.getElementById("edit_paper_title").value;
    if (paper_title == null || paper_title.length ==0){          
        alert("试卷标题不能为空。");        
        return false;
    }
    return true;
}

//验证 修改模块信息
function edit_block_info(id){
    var block_title=document.getElementById("edit_block_title_"+id).value;
    if (block_title == null || block_title.length ==0){
        alert("模块标题不能为空。");
        return false;
    }
    return true;
}

//验证 编辑题目
function edit_problem_validate(problem_id){
    var problem_title = KE.util.getData("edit_title_"+problem_id).replace(/<br \/>/g,"");
    var text_source = problem_title.replace(/^\s+/, "").replace(/ \s+$/, "");
    if(problem_title == null  || problem_title.length == 0 || checkspace(text_source)){
        alert("题面不能为空。");
        return false;
    }

    if(document.getElementById("problem_description")!=null){           //验证小题描述不能为空
        var problem_description = document.getElementById("problem_description").value;
        if (problem_description==""){
            alert("描述不能为空。");
            return false;
        }
    }

    var answer_array=new Array;
    for(var i=1;i<=4;i++){     //验证 选项不能为空
        if(document.getElementById("problem_attr"+i+"_value")!=null){
            var attr_value = document.getElementById("problem_attr"+i+"_value").value;
            answer_array.push(attr_value);
            if (attr_value==""){
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


    if(document.getElementById("problem_answer")!=null){           //验证答案不能为空
        var problem_answer = document.getElementById("problem_answer").value;
        if (problem_answer==""){
            alert("答案不能为空。");
            return false;
        }
    }


    var checked_num = 0;                               //验证是否选择正确答案,单选,多选都可用
    for(i=0;i<4;i++){
        if(document.getElementById("problem_attr_key_"+(i+1)).checked){
            checked_num++;
        }
    }
    if (checked_num==0){
        alert("请设置正确选项。");
        return false;
    }
    
    alert("end");
    return false;
}


//验证 新建试题
function new_problem_validate(block_id){
 
    var problem_title = KE.util.getData("problem_title_"+block_id).replace(/<br \/>/g,"");
    var text_source = problem_title.replace(/^\s+/, "").replace(/ \s+$/, "");
    if(problem_title == null  || problem_title.length == 0 || checkspace(text_source)){
        alert("题面不能为空。");
        return false;
    }

    if(document.getElementById("problem_description")!=null){           //验证小题描述不能为空
        var problem_description = document.getElementById("problem_description").value;
        if (problem_description==""){
            alert("描述不能为空。");
            return false;
        }
    }


    if(document.getElementById("problem_attr1_value")!=null){
        var answer_array=new Array;
        for(var i=1;i<=4;i++){     //验证 选项不能为空
            var attr_value = document.getElementById("problem_attr"+i+"_value").value;
            answer_array.push(attr_value);
            if (attr_value==""){
                alert("选项不能为空。");
                return false;
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
        if (problem_answer==""){
            alert("答案不能为空。");
            return false;
        }
    }

    //验证是否选择正确答案,单选,多选都可用
    if(document.getElementById("problem_attr_key_1")!=null){
        var checked_num = 0;
        for(i=0;i<4;i++){
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


//验证  新建模块
function new_module_validate(){
    var new_module_title = document.getElementById("new_module_title").value;
    if ( new_module_title == null || new_module_title.length == 0 ){
        alert("模块标题不能为空。");
        return false;
    }
    return true;
}