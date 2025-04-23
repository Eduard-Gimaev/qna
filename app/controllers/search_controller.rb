class SearchController < ApplicationController
  def index
    @query = params[:query]
    @scope = params[:scope]

    @results = case @scope
               when 'questions'
                 Question.search(@query)
               when 'answers'
                 Answer.search(@query)
               when 'comments'
                 Comment.search(@query)
               when 'users'
                 User.search(@query)
               else
                 ThinkingSphinx.search(@query)
               end
  end
end
