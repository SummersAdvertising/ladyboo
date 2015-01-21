# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

env :PATH, ENV['PATH']

set :output, 'log/whenever.log'
#set :environment, :production


# every :day, :at => '3am' do
#   rake "whenever:disable_expired_gives"
# end

every 3.days do
  #runner "Order.delete_hold_orders"
  rake "whenever:delete_hold_orders"
  #rake "whenever:check_deals_waitpay"
end

every :day, :at => '15:02am'  do
  rake "whenever:calculate_daily_report"
end

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
