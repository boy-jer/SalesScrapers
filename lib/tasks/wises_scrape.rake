desc "Fetch Businesses"
task :wises_scrape => :environment do

  keyword = ENV['KEYWORD'] || abort('Need keyword. E.g: "KEYWORD=electricians"')
  location = ENV['LOCATION'] || abort('Need location. E.g: "LOCATION=Wellington"') 

  require 'nokogiri'  
  require 'open-uri'

  fetch(keyword,location)
  export(keyword,location)
end

def fetch(keyword,location)
  keyword_for_url = keyword.gsub(/\s+/, '+')
  location_for_url = location.gsub(/\s+/, '+')
  url = "http://www.wises.co.nz/rlb/k/1/#{location_for_url}/#{keyword_for_url}/"
  doc = Nokogiri::HTML(open(url))
  raw_results_count = doc.xpath('//div[@id = "results"]//div[@id = "search-results-header"]//span//text()').collect[0].to_s
  
  if raw_results_count == ""
    results_count = 10
  else
    results_count = raw_results_count.scan(/of ([0-9]+)\)/)[0][0].to_i
  end
  
  puts "Found #{results_count} results"
  
  count = 0
  while count < results_count
    page_url = "#{url}s/#{count.to_s}/"
    page = Nokogiri::HTML(open(page_url))

    page.xpath('//div[@id = "results"]//dl[@id = "resultsList"]//dt').each do |result|
      finda_id = result.xpath('div').map { |data| data['id'] }.to_s.split('result')[1]
      result_object = WisesScrape.find_by_finda_id(finda_id)

      if result_object
        puts "Result already added: #{result_object.name}"
      else
        result_name = result.xpath('div//strong[@class = "fullname"]//text()').to_s.gsub(/&amp;/, '&')
        finda_url = page.xpath("//dd[@id = \"result#{finda_id}Details\"]//a[@class = \"more_info\"]").map { |link| link['href'] }.to_s
        telephone = page.xpath("//dd[@id = \"result#{finda_id}Details\"]//em//text()").to_s.gsub(/Tel /, '')
        result_size = fetch_employee_size(finda_url)
        
        puts "Inserting: #{result_name} - #{finda_id}"
        result_new = WisesScrape.new(:finda_id => finda_id, :name => result_name, :keyword => keyword, :location => location, :size => result_size, :finda_url => finda_url, :telephone => telephone)
        result_new.save
      end
    end
    count += 10
  end
end

def fetch_employee_size(finda_url)
  begin
    finda_page = Nokogiri::HTML(open(finda_url))
    result_size = finda_page.xpath('//div[@id = "content-main"]//div[@id = "detail"]//div[@class = "info"]//div[h3 = "Size"]/p/text()').to_s
  rescue
    result_size = ""
  end
end

def export(keyword,location)
  require 'csv'

  results = WisesScrape.find(:all, :conditions => ['keyword = ? AND location = ?', keyword, location])
  outfile = File.open("tmp/wises_scrape-#{keyword.camelize}-#{location.camelize}.csv", 'wb')

  CSV::Writer.generate(outfile) do |csvtext|
    csvtext << ["name", "keyword", "location", "size", "telephone"]
    results.each do |result|
      csvtext << [result.name, result.keyword, result.location, result.size, result.telephone]
    end
  end
  outfile.close
end
