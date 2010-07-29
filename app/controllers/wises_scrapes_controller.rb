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
end
