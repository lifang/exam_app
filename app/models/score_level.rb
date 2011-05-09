class ScoreLevel < ActiveRecord::Base
 belongs_to :examination

  #创建分数等级
  def ScoreLevel.create_score_level(attr_hash)

    #return score_level
  end
end