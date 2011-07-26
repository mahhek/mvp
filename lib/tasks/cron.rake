desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour % 1 == 0 # run every four hours
    puts "Updating feed..."
    puts "...................................................................................."
    puts "done."
  end  
end