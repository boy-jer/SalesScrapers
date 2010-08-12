require "fastercsv"

class WisesScrape < ActiveRecord::Base

  default_scope :order => "name ASC"

  def to_csv
    FasterCSV.generate_line([ name, keyword, location, size, telephone ])
  end
end
