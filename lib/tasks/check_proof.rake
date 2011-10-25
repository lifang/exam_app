# encoding: utf-8

namespace :check do
  desc "check proof right"
  task(:proof => :environment) do
    proofs=Proof.where("checked=0")
    unless proofs==[]
      UserMailer.check_proofs.deliver
    end
  end
end
