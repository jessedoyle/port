class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :absolute_path
      t.string :relative_path
      t.boolean :public, default: false

      t.timestamps null: false
    end
  end
end
