class AddUserIdColumn < ActiveRecord::Migration
  def change
    add_column :cats, :user_id, :integer, presence: true
    add_index :cats, :user_id
  end
end
