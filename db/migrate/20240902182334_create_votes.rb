class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :vote_type, null: false
      t.belongs_to :user, foreign_key: { on_delete: :cascade }
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, %i[user_id votable_id votable_type], unique: true, name: 'index_votes_on_user_and_votable'
  end
end
