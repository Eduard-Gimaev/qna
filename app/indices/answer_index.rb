ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body
  indexes user.email, as: :author, sortable: true
  indexes question.title, as: :question_title

  has created_at, updated_at
end
