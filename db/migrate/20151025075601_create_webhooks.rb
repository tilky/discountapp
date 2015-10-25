class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :wb_id
      t.integer :ord_cnt
      t.string :ord_id
      t.boolean :dscnt

      t.timestamps
    end
  end
end
