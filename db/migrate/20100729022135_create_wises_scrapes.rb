class CreateWisesScrapes < ActiveRecord::Migration
  def self.up
    create_table :wises_scrapes do |t|
      t.string :finda_id
      t.string :keyword
      t.string :name
      t.string :location
      t.string :size
      t.string :finda_url
      t.string :telephone

      t.timestamps
    end
  end

  def self.down
    drop_table :wises_scrapes
  end
end
