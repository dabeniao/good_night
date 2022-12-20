class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.bigint :follower_user_id, null: false
      t.bigint :following_user_id, null: false

      t.timestamps
    end

    add_index :relationships, [:follower_user_id, :following_user_id], unique: true
    add_index :relationships, [:following_user_id, :follower_user_id], unique: true
  end
end
