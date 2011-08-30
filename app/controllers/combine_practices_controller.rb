class CombinePracticesController < ApplicationController
  
  def index
     @combine_practices=Examination.find_by_sql("select * from examinations where types in (2,3,4,5,6)")
  end

end
