#encoding: utf-8
namespace :whenever do

  desc "Find those HOLD orders"
  task :delete_hold_orders => :environment do
    Order.delete_hold_orders
  end
  desc "Add member the basic role to user"
  task :add_member_role => :environment do
    User.all.each do |usr|
      usr.add_role :member
      puts usr.email
    end
    puts 'All done'
  end

end