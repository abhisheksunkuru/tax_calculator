class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :eid, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.date :doj, null: false
      t.integer :salary, null: false, default: 0.0
      t.timestamps
    end
  end
end
