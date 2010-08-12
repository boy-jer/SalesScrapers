class WisesScrapesController < ApplicationController
  # GET /wises_scrapes
  # GET /wises_scrapes.xml
  def index
    @wises_scrapes = WisesScrape.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wises_scrapes }
    end
  end

  # GET /wises_scrapes/1
  # GET /wises_scrapes/1.xml
  def show
    @wises_scrape = WisesScrape.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wises_scrape }
    end
  end

  # GET /wises_scrapes/new
  # GET /wises_scrapes/new.xml
  def new
    @wises_scrape = WisesScrape.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wises_scrape }
    end
  end

  # GET /wises_scrapes/1/edit
  def edit
    @wises_scrape = WisesScrape.find(params[:id])
  end

  # POST /wises_scrapes
  # POST /wises_scrapes.xml
  def create
    @wises_scrape = WisesScrape.new(params[:wises_scrape])

    respond_to do |format|
      if @wises_scrape.save
        format.html { redirect_to(@wises_scrape, :notice => 'WisesScrape was successfully created.') }
        format.xml  { render :xml => @wises_scrape, :status => :created, :location => @wises_scrape }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wises_scrape.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wises_scrapes/1
  # PUT /wises_scrapes/1.xml
  def update
    @wises_scrape = WisesScrape.find(params[:id])

    respond_to do |format|
      if @wises_scrape.update_attributes(params[:wises_scrape])
        format.html { redirect_to(@wises_scrape, :notice => 'WisesScrape was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wises_scrape.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wises_scrapes/1
  # DELETE /wises_scrapes/1.xml
  def destroy
    @wises_scrape = WisesScrape.find(params[:id])
    @wises_scrape.destroy

    respond_to do |format|
      format.html { redirect_to(wises_scrapes_url) }
      format.xml  { head :ok }
    end
  end
  
  def fetch
    keyword = params[:keyword]
    location = params[:location]
    
    require 'nokogiri'
    require 'open-uri'
    
    keyword_for_url = keyword.gsub(/\s+/, '+')
    location_for_url = location.gsub(/\s+/, '+')
    url = "http://www.wises.co.nz/rlb/k/1/#{location_for_url}/#{keyword_for_url}/"
    doc = Nokogiri::HTML(open(url))
    raw_results_count = doc.xpath('//div[@id = "results"]//div[@id = "search-results-header"]//span//text()').collect[0].to_s

    if raw_results_count == ""
      results_count = 10
      @wises_scrape = [ "Found 10 or less results for #{keyword} in #{location}" ]
    else
      results_count = raw_results_count.scan(/of ([0-9]+)\)/)[0][0].to_i
      @wises_scrape = [ "Found #{results_count} results for #{keyword} in #{location}" ]
    end

    count = 0
    while count < results_count
      page_url = "#{url}s/#{count.to_s}/"
      page = Nokogiri::HTML(open(page_url))

      page.xpath('//div[@id = "results"]//dl[@id = "resultsList"]//dt').each do |result|
        finda_id = result.xpath('div').map { |data| data['id'] }.to_s.split('result')[1]
        result_object = WisesScrape.find_by_finda_id(finda_id)

        if result_object
#          @wises_scrape << "Result already added: #{result_object.name}"
        else
          result_name = result.xpath('div//strong[@class = "fullname"]//text()').to_s.gsub(/&amp;/, '&')
          finda_url = page.xpath("//dd[@id = \"result#{finda_id}Details\"]//a[@class = \"more_info\"]").map { |link| link['href'] }.to_s
          telephone = page.xpath("//dd[@id = \"result#{finda_id}Details\"]//em//text()").to_s.gsub(/Tel /, '')
          result_size = fetch_employee_size(finda_url)

#          @wises_scrape <<  "Inserting: #{result_name} - #{finda_id}"
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

  def export
    keyword = params[:keyword]
    location = params[:location]
    @wises_scrape = WisesScrape.find(:all, :conditions => { :keyword => keyword, :location => location })
    respond_to do |format|
      format.csv do
        response.headers["Content-Type"]        = "text/csv; charset=UTF-8; header=present"
        response.headers["Content-Disposition"] = "attachment; filename=wises_scrape-#{keyword.underscore}-#{location.underscore}.csv"
      end
    end
  end

end
