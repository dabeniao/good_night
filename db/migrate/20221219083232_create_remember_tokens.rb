class CreateRememberTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :remember_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end
  end
end
