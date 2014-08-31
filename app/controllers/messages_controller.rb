class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :owned_message, only: [:show]

  def new
    @message = current_user.messages.build
  end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      flash[:success] = 'Message sent!'
      redirect_to messages_path
    else
      render 'new'
    end
  end

  def index
    @messages = current_user.received_messages.paginate(page: params[:page])
  end

  def show
    @message = Message.find(params[:id])
  end

  def sent
    @messages = current_user.messages.paginate(page: params[:page])
  end

  private
    def message_params
      params.require(:message).permit(:content, :to, :receiver_id)
    end

    def owned_message
      @message =  Message.find(params[:id])
      redirect_to(root_url) unless current_user?(@message.sender) || current_user?(@message.receiver)
    end
end
