

function item_pools_create_question(){
    $("item_pools_button").style.display = "none";
    $("create_question").style.display = "block";
    item_pools_get_question_type();
}

function item_pools_get_question_type(correct_type, remote_div) {
    var problem_type = "";
    var question_type = "";
    var types = document.getElementsByName("type_radio");
    for (var i=0; i<types.length; i++) {
        if (types[i].checked == true) {
            problem_type = types[i].value;
        }
    }
    $("real_type").value = problem_type;
    $("choose_que_type_div").style.display = "none";
    if (correct_type == null) {
        question_type = problem_type;
    }
    else {
        question_type = correct_type;
    }
    if (remote_div == "remote_que_div_") {
        $("choose_coll_que").style.display = "none";
        $("choose_coll_que_link").style.display = "none";
    }
    new Ajax.Updater("" + remote_div, "/paper_blocks/" + block_id + "/choose_type",
    {
        asynchronous:true,
        evalScripts:true,
        method:"post",
        parameters:'problem_type=' + problem_type + '&question_type='+ question_type +
        '&authenticity_token=' + encodeURIComponent('kfCK9k5+iRMgBOGm6vykZ4ekez8CB77n9iApbq0omBs=')
    });
    return false;
}