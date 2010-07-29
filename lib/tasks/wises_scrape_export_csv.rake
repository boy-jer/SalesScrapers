namespace :wises_scrape do
  
  desc "Export Wises Scrape to CSV"
  task :export_to_csv => :environment do
    require 'csv'
    
    results = WisesScrape.find(:all)
    outfile = File.open('tmp/wises_scrape.csv', 'wb')
    
    CSV::Writer.generate(outfile) do |csvtext|
      csvtext << ["name", "keyword", "location", "size"]
      results.each do |result|
        csvtext << [result.name, result.keyword, result.location, result.size]
      end
    end
  end
  
end