class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        cookies[:auth_token] = @user.auth_token
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_login_session
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
        # user.auth_token = SecureRandom.urlsafe_base64
        # user.save
      if params[:rememberme]
        cookies.permanent[:auth_token] =user.auth_token #持久化保存
      else
        cookies[:auth_token] = user.auth_token #临时性保存 类似 session
      end
      redirect_to :root
    else
      flash.notice = "用户名密码错误!"
      redirect_to :login
    end
  end

  def login
  end
  def logout
    cookies.delete(:auth_token)
    redirect_to :root
  end
  def avatar
    current_user.avatar=user_params[:avatar]
    current_user.save!
    redirect_to :root
  end
  def info
    @user = current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nickname, :username, :email, :password, :avtar)
    end
end
