desc "Imports the news from PJA's website"
task import: :environment do
  puts "Attempting import at #{Time.zone.now}"
  begin
    ImportService.new.call
  rescue StandardError => e
    puts "An error occured: #{e.to_s}"
  end
end
