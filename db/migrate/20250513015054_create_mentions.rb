class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.belongs_to :report_from, class_name: 'Report'
      t.belongs_to :report_to, class_name: 'Report'
      t.timestamps
    end
    add_index :mentions, [:report_from_id, :report_to_id], unique: true
  end
end
