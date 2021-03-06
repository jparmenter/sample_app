class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :not_signed_in_user, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @user = User.find(params[:id])
    show_follow("Following", @user.followed_users)
  end

  def followers
    @user = User.find(params[:id])
    show_follow("Followers", @user.followers)
  end

  private
    def user_params
      params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
    end

    def not_signed_in_user
      redirect_to root_url, notice: "You are already signed in." unless !signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin? && !current_user?(@user)
    end

    def show_follow(title, users)
      @title = title
      @users = users.paginate(page: params[:page])
      render 'show_follow'
    end
end
