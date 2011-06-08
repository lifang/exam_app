
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
function edit_problem_form(id){
    
}


//验证 新建试题
function new_problem_validate(block_id){
    var problem_title = KE.util.getData("problem_title_"+block_id).replace(/<br \/>/g,"");
    if(problem_title == null  || problem_title.length == 0){
        alert("题面不能为空。");
        return false;
    }
    
    if (checkspace(problem_title)){      //有问题  题面不能全为空格
        alert("题面不能为空111。");
        return false;
    }

    if("选项不能为空"){      //选项不能为空

    }

    if("分值不能为空"){      //分值不能为空

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