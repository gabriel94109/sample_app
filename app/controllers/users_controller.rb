class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page], :per_page => 5)
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page], :per_page => 5)
    render 'show_follow'
  end

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      @title = 'Sign up'
      render 'new'
    end
  end

  def index
    @title = 'Search all users'
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 5)
  end

  def show
    if(params[:username])
      @user = User.find_by_name(params[:username])
    else
      @user = User.find(params[:id])
    end
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => 5)
    @title = @user.name

    respond_to do |format|
      format.html
      format.rss {render :layout => false }
    end
  end

  def edit
    @title = 'Edit user'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated.'
      redirect_to(@user)
    else
      @title = 'Edit user'
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to(users_path)
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
