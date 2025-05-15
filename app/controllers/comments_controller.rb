# frozen_string_literal: true

class CommentsController < ApplicationController
  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])

    redirect_to @comment.commentable if @comment.user != current_user
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id))

    if @comment.save
      redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    if @comment.user == current_user && @comment.update(comment_params)
      redirect_to @comment.commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    if @comment.user == current_user && @comment.destroy
      redirect_to @comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      redirect_to @comment.commentable, notice: t('controllers.common.notice_unable_destroy', name: Comment.model_name.human)
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
