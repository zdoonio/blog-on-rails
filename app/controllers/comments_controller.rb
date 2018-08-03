class CommentsController < ApplicationController  
    before_action :authenticate_user!, only: [:create, :destroy]
    
    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params())
        @comment.user_id = current_user.id
            if @comment.save
                flash[:notice] = "Comment added."
                redirect_to post_path(@post)
            else
                flash[:alert] = "There is some errors."
                redirect_to post_path(@post)
            end    
    end
    
    def destroy
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        if @comment.user.id == current_user.id
            @comment.destroy
            flash[:notice] = "Comment deleted."
            redirect_to post_path(@post)
        else 
            flash[:alert] = "That comment does not belongs to you."
            redirect_to post_path(@post)
        end        
    end    

    private 

    def comment_params
        params.require(:comment).permit(:body)
    end    

end
