module ProblemsHelper
  
  #组装答案和选项
  def answer_text(problem_type, attr_num, answer,question_id="")
    answer_question_attr = []
    attrs_array = []
    if problem_type == Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      answer_index = params["attr_key#{question_id}"].to_i
      answer_question_attr << params["attr#{answer_index}_value#{question_id}"]
      (1..attr_num).each do |i|
        if !params["attr#{i}_value#{question_id}"].nil? && params["attr#{i}_value#{question_id}"] != ""
          attrs_array << params["attr#{i}_value#{question_id}"]
        end
      end
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:MORE_CHOSE] or problem_type == Problem::QUESTION_TYPE[:MORE_BLANKS]
      answer_index = []
      (1..attr_num).each do |i|
        if !params["attr#{i}_key#{question_id}"].nil? and params["attr#{i}_key#{question_id}"] != ""
          attr_key = params["attr#{i}_key#{question_id}"].to_i
          answer_index << params["attr#{attr_key}_value#{question_id}"]
        end
        if !params["attr#{i}_value#{question_id}"].nil? && params["attr#{i}_value#{question_id}"] != ""
          attrs_array << params["attr#{i}_value#{question_id}"]
        end
      end
      answer_question_attr << answer_index.join(";|;")
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:JUDGE]
      answer_question_attr << params["attr_key#{question_id}"].to_i
      answer_question_attr << []
    elsif problem_type == Problem::QUESTION_TYPE[:SINGLE_CALK] or problem_type == Problem::QUESTION_TYPE[:CHARACTER]
      answer_question_attr << answer
      answer_question_attr << []
    end
    return answer_question_attr
  end

end
