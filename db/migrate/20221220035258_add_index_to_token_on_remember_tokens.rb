class AddIndexToTokenOnRememberTokens < ActiveRecord::Migration[7.0]
  def change
    add_index :remember_tokens, :token, unique: true
  end
end
