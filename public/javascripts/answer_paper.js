//用来返回问题是否已经回答
function generate_problem_answer(problem_id) {
    var problem_div = $("full_problem_" + problem_id);
    var question_ids = $("question_ids_" + problem_id).value;
    if (question_ids != "") {
        var ids = question_ids.split(",");
        var is_answer_num = 0;
        for (var i=0; i<ids.length-1; i++) {
            var question_div = $("question_" + ids[i]);
            if (question_div != null) {
                var is_answer = question_value(ids[i]);
                if (is_answer) {
                    is_answer_num++ ;
                }
            }
        }
        if (is_answer_num == (ids.length-1)) {
            $("li_" + problem_id).style.background = "#A3C6C8";
            problem_div.style.background = "#A3C6C8";
            $("is_answer_" + problem_id) = "1";
        } else {
            $("li_" + problem_id).style.background = "#fff2f2";
            problem_div.style.background = "#fff2f2";
        }
        $("question_info_" + problem_id).style.display = "none";
    }  
}

//用来返回每个提点是否已经回答
function question_value(question_id) {
    var is_answer = false;
    $("answer_" + question_id).value = "";
    var correct_type = $("question_type_" + question_id).value;
    if (correct_type == "0" || correct_type == "1" || correct_type == "2") {
        var attr = document.getElementsByName("question_attr_" + question_id);
        if (attr != null) {
            for (var i=0; i<attr.length; i++) {
                if (attr[i].checked == true) {
                    $("answer_" + question_id).value += "" + attr[i].value + ",";
                    is_answer = true;
                }
            }
        }
    } else {
        var answer = $("question_answer_" + question_id);
        if (answer != null && !checkspace(answer.value)) {
            is_answer = true;
            $("answer_" + question_id).value = answer.value;
        }
    }
    return is_answer;
}

function generate_result_paper(paper_id) {
    //var all_question_ids = $("all_question_ids").value;
    var all_problem_ids = $("problem_ids");
    if (all_problem_ids != null && all_problem_ids.value != "") {
        var problem_ids = all_problem_ids.value.split(",");
        var answer_length = 0;
        for (var i=0; i<problem_ids.length-1; i++) {
            var is_answer = $("is_answer_" + problem_ids[i]);
            if (is_answer != null && is_answer.value != null) {
                if (is_answer.value == "1") {
                    answer_length++ ;
                }
            }            
        }
        if (answer_length < (problem_ids.length-1)) {
            
            alert("您还有题尚未答完，确定要交卷么");
        }
    }
    return false;
}

