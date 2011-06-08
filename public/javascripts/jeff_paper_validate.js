
//验证  修改试卷基本信息
function edit_paper_info(){
    var paper_title=document.getElementById("edit_paper_title").value;
    if (paper_title == null || paper_title.length ==0){          
        alert("试卷标题不能为空。");        
        return false;
    }
}

//验证 修改模块信息
function edit_block_info(id){
    var block_title=document.getElementById("edit_block_title_"+id).value;
        if (block_title == null || block_title.length ==0){
        alert("模块标题不能为空。");
        return false;
    }
}