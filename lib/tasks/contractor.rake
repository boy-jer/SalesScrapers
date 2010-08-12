namespace :contractors do

  desc "Fetch All Contractors"  
  task :fetch => :environment do
    require 'nokogiri'  
    require 'open-uri'  
    
    fetch_ids
    fetch_operations_count
  end
  
  def fetch_ids
    url = "http://www.ruralcontractors.org.nz/findacontractor.asp?council=&operation="
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//table[@id = "results"]//tr[position()>1]').each do |contractor|
      contractor_name = contractor.xpath('td[1]//text()').collect[0].to_s.gsub(/&amp;/, '&')
      contractor_district = contractor.xpath('td[1]/span[@class = "grey"]').text
      contractor_id = contractor.xpath('td[2]//div[@id = "more"]/a').map { |link| link['href'] }.to_s.gsub(/[^0-9]/, '').to_i
      
      contractor = Contractor.find_by_contractor_id(contractor_id)
      if contractor
        puts "Contractor already added"
      else
        contractor_new = Contractor.new(:contractor_id => contractor_id, :name => contractor_name, :district => contractor_district)
        contractor_new.save
      end
    end

  end

  def fetch_operations_count
    url_base = "http://www.ruralcontractors.org.nz/contractordetail.asp?ID="
    contractor_ids = Contractor.find(:all, :select => "contractor_id")
    all_count = contractor_ids.count
    progress_count = 0
    contractor_ids.each do |contractor_id|
      id = contractor_id['contractor_id']
      page_url = url_base + id.to_s
      doc = Nokogiri::HTML(open(page_url))
      count = 0
      doc.xpath('//table[@id = "results"]//tr').each do |row|
        count += 1
      end
      contractor = Contractor.find_by_contractor_id(id)
      contractor[:operations_count] = count
      contractor.save
      progress_count += 1
      puts "#{progress_count} / #{all_count} pages done..." if progress_count % 10 == 0
    end
    
    puts "All operations added"
  end

  def clean_all
    count = contractor.all.count
    contractor.delete_all
    puts "#{count} have been deleted"
  end
end