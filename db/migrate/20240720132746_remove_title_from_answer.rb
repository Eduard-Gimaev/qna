class RemoveTitleFromAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :answers, :title
  end
end
