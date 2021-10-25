class AddsZurichExpatsUsername < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :zurichexpats_created_at, :datetime
    add_column :users, :zurichexpats_username, :string
  end
end
