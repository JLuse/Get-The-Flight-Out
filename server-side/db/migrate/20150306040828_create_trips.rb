class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :sale_total
      t.string :carrier
      t.integer :flight_number
      t.string :depart_time
      t.string :arrival_time
      t.integer :duration
      t.integer :mileage

      t.timestamps null: false
    end
  end
end
