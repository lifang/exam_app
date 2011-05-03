
function create_question(id){
    if(document.getElementById("create_question_"+id).style.display=="block"){
        document.getElementById("create_question_"+id).style.display="none";
    }else{
        document.getElementById("create_question_"+id).style.display="block";
    }
}


function change_info(){
     document.getElementById("change_info").style.display="block";
     document.getElementById("show_info").style.display="none";
}

function new_module(){
     if(document.getElementById("new_module").style.display=="block"){
        document.getElementById("new_module").style.display="none";
    }else{
        document.getElementById("new_module").style.display="block";
    }
}

