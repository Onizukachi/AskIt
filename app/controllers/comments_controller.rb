# frozen_string_literal: true

class CommentsController < ApplicationController
  include QuestionsAnswers

  def create
    @comment = @commentable.comments.build comment_params

    if @comment.save
      flash[:success] = t. 'success'
      redirect_to question_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end