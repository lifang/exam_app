require 'spec_helper'

describe Question do
  it "should return a score array" do
    @content = "where[(5)] are you going?[(4)],how are you?[(3,|2)]"
    @score_arr = Question.generate_score_or_analysis(@content, ")]", "[(")
    @score_arr.should == ["5","4","3","2"]
  end

  it "should return a analysis array" do
    @content = "where[{jiexi1}] are you going?[{jiexi2}],how are you?[{jiexi3,|jiexi4}]"
    @analysis_arr = Question.generate_score_or_analysis(@content, "}]", "[{")
    @analysis_arr.should == ["jiexi1","jiexi2","jiexi3","jiexi4"]
  end

end
