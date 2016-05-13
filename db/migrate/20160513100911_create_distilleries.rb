# encoding: utf-8
class CreateDistilleries < ActiveRecord::Migration
  def change
    create_table :distilleries do |table|
      table.string        :token, limit: 8
      table.string        :name, limit: 64
      table.string        :title, limit: 64
      table.string        :slug, limit: 128
      table.string        :phonetic, limit: 128, null: true
      table.string        :respelling, limit: 128, null: true
      table.string        :meaning, limit: 128, null: true
      table.text          :description
      table.integer       :status, default: 0
      table.integer       :state, default: 0
      table.datetime      :deleted_at, null: true
      table.timestamps    null: true
    end
    add_index :distilleries, :deleted_at
  end
end
