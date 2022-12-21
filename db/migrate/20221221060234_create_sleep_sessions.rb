class CreateSleepSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :slept_at, null: false
      t.datetime :woke_at, null: false

      t.timestamps
    end

    add_index :sleep_sessions, [:user_id, :created_at]
  end
end
