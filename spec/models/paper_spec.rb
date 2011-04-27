require 'spec_helper'

describe Paper do
 before(:each) do
   @attr={:title=>"example",:types=>"java",:user_id=>1,:description=>"ssdfgggg",:total_question_num=>12,:total_score=>"100"}
 end
 it "should accept valid" do
   get :edit
 end

end
