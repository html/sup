class UsersController < ApplicationController
  before_filter :assign_subjects
  before_filter :assign_places
  before_filter :require_login, :only => [:logout]
  before_filter :require_login, :only => [:change_password], :if => lambda { |x| !x.params[:recover] }

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

  def forgot_password
    if request.post? && params[:typus_user]
      @user = TypusUser.find_by_email params[:typus_user][:email]
      ForgotPassword.deliver_index_notification(@user, request.env['HTTP_HOST'])

      if @user
        @user.generate_recovery_hash

        flash[:notice] = 'Пожалуйста проверьте почтовый ящик'
        redirect_to root_url
      end
    end
  end

  def change_password

    if params[:recover]
      @recover = params[:recover]
      @current_user = TypusUser.find_by_recovery_hash(@recover)

      unless @current_user
        flash[:notice] = "Код для восстановления не верный, попробуйте еще раз"
        return redirect_to forgot_password_url
      end
    end

    if request.post?
      if @current_user.change_password(params[:typus_user])
        flash[:notice] = 'Пароль успешно изменен'
        redirect_to root_url
      end
    end
  end
end
