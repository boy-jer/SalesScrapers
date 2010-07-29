namespace :contractors do
  
  task :export_to_csv => :environment do
    require 'csv'
    
    contractors = Contractor.find(:all)
    outfile = File.open('tmp/contractors.csv', 'wb')
    
    CSV::Writer.generate(outfile) do |csvtext|
      csvtext << ["name", "district", "operations_count"]
      contractors.each do |contractor|
        csvtext << [contractor.name, contractor.district, contractor.operations_count]
      end
    end
  end
  
end