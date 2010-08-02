# Sales Scrapers

So one of the sales guys walks over and says, "Jono, I have found this xyz search/directory website with lots of possible customers on it. But, I need to qualify them into more suitable groups."

The xyz website has data about how many services they offer, or how many staff they have, so that tells the sales guy how suitable they would be as a customer.

So, we will scrape the useful bits of the website into rows in the local DB, then spit it out as CSV. The sales guy is happy to deal with CSV in a mostly raw format.

I don't really need a full Rails app to do all this, but I get everything I needed for free, and running up the web server gives me a quick view on the data.

# Setup

## Required Gems

* rails stack
* nokogiri
* open-uri

## DB

I just use SQLite3.

    rake db:migrate

# Nokogiri Scrape and CSV Export

I'm using Nokogiri in Rake tasks to scrape the data, then export to CSV.

CSV Exports are sent to tmp/*.csv

## Wises website

One of the best stocked [NZ business findas](http://www.wises.co.nz/) ;-)

### Scrape and Export to CSV

Two arguments required:

* KEYWORD (the search keyword. E.g: electricians)
* LOCATION (the city/province to search in. E.g: Wellington)

Scrape Command:

    rake wises_scrape KEYWORD=electricians LOCATION=Wellington
    
CSV Output goes to tmp/wises_scrape-[KEYWORD]-[LOCATION].csv


## Rural Contractors Website

[This website](http://ruralcontractors.org.nz/FindaContractor.asp) lists a few hundred of NZs Rural Contractors.

### Scrape
No arguments, it just scrapes everything off the site:

    rake contractors:fetch
    
### Export to CSV

    rake contractors:export_to_csv
    
# Review Data via Webserver

Start the server:

    script/server

### Wises Scrapes:

[http://localhost:3000/wises_scrapes](http://localhost:3000/wises_scrapes)

### Rural Contractors Scrapes:

[http://localhost:3000/contractors](http://localhost:3000/contractors)


