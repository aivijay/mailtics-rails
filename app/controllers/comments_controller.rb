class CommentsController < ApplicationController
  before_filter :load_campaign, :except => :destroy
  before_filter :authenticate, :only => :desctory

  def create
    @comment = @campaign.comments.new(params[:comment])
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @campaign, :notice => "Comment added" }
        logger.warn "debug: ----------------------------------> FORMAT JS data sent"
        format.js { render 'create.js.erb' }
      
        logger.warn "debug: ----------------------------------> FORMAT JS data sent - AFTER"
      end
    else
      respond_to do |format|
        format.html { redirect_to @campaign, :alert => 'Unable to add comment' }
        format.js { render 'fail_create.js.erb' }
      end
    end
  end
  def destroy
    @campaign = current_user.campaigns.find(params[:campaign_id])
    @comment = @campaign.comments.find(params[:id])
    @comment.destroy
    redirect_to @campaign, :notice => 'Comment deleted'
  end
  private
    def load_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end
end
