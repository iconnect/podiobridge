class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :message
      t.string :sender

      t.timestamps null: false
    end
  end
end
