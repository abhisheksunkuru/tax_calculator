class CreatePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.string :number, null: false
      t.references :employee
      t.timestamps
    end
  end
end
