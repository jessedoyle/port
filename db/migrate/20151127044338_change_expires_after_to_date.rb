class ChangeExpiresAfterToDate < ActiveRecord::Migration
  def change
    change_column :access_keys, :expires_after, :date
  end
end
