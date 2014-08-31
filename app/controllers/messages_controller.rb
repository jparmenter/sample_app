class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :set_message, only: [:show, :destroy]
  before_action :correct_user, only: [:show, :destroy]

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
  end

  def sent
    @messages = current_user.messages.paginate(page: params[:page])
  end

  def destroy
    @message.destroy
    flash[:success] = "Message deleted!"
    redirect_to messages_path
  end

  private
    def message_params
      params.require(:message).permit(:content, :to, :receiver_id)
    end

    def set_message
      @message = Message.find(params[:id])
    end

    def correct_user
      @message =  Message.find(params[:id])
      redirect_to(root_url) unless current_user?(@message.sender) || current_user?(@message.receiver)
    end
end
