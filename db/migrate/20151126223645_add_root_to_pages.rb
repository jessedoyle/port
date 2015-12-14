class AddRootToPages < ActiveRecord::Migration
  def change
    add_column :pages, :root, :string
  end
end
