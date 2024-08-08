# frozen_string_literal: true

class AddAuthorToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :user, foreign_key: true
  end
end
