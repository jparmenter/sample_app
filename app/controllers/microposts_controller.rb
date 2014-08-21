class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @user = current_user
    @micropost = current_user.microposts.build(micropost_params)
    parse_recipient!(@micropost)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def parse_recipient!(micropost)
      username_match = User.reply_match(micropost.content)
      if !username_match.nil?
        recipient = User.find_by(username: username_match[1])
        @micropost.in_reply_to = recipient.id unless recipient.nil?
      end
    end
end
