class CreateAccessKeys < ActiveRecord::Migration
  def change
    create_table :access_keys do |t|
      t.string :value
      t.datetime :expires_after

      t.timestamps null: false
    end
  end
end
