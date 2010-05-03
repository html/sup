class UsersController < ApplicationController
  before_filter :assign_subjects
  before_filter :assign_places

  def register

    if request.post?
      @user = TypusUser.new(params[:typus_user].merge(:role => 'user'))

      if @user.valid? && @user.save
        flash[:notice] = 'Успешно зарегистрировались'
        redirect_to root_url
      end
    else
      @user = TypusUser.new
    end
  end

  def login
    @user = TypusUser.new

    if request.post?
      @auth_user = TypusUser.authenticate_by_login_and_password(params[:typus_user][:login], params[:typus_user][:password])

      if @auth_user
        session[:typus_user_id] = @auth_user.id
        flash[:notice] = 'Успешно вошли'
        redirect_to root_url
      else
        @user.errors.add_to_base 'Пользователь с такими именем/паролем не найден'
      end
    end
  end

  def logout
    session[:typus_user_id] = nil
    flash[:notice] = 'Успешно вышли'
    redirect_to root_url
  end
end
