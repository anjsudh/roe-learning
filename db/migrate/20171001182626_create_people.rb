class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.float :employeeId, :unique=>true
      t.string :preferredName
      t.integer :gender
      t.integer :role
      t.integer :grade
      t.string :picture
      t.decimal :totalExperience
      t.decimal :twExperience
      t.string :homeOffice
      t.boolean :assignable
      t.boolean :inBeach
      t.decimal :timeInCurrentAccount
      t.timestamps
    end
  end
end
