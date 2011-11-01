# encoding: utf-8

namespace :check do
  desc "check proof right"
  task(:proof => :environment) do
    proofs=Proof.where("checked=0")
    puts "proof start"
    UserMailer.check_proofs(proofs.size).deliver unless proofs.blank?
    puts "proof start"
  end
end
