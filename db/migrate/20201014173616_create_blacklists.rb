class CreateBlacklists < ActiveRecord::Migration[6.0]
  def change
    create_table :blacklists do |t|
      t.string :jwt
      t.datetime :expiration

      t.timestamps
    end
  end
end
