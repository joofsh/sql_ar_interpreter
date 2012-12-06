class Query < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :ar_query
      t.string :sql_query
      t.string :url

      t.timestamps
    end
  end
end
