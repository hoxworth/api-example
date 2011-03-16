class CreateDroids < ActiveRecord::Migration
  def self.up
    create_table :droids do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :droids
  end
end
