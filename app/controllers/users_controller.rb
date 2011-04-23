class UsersController < ApplicationController
  before_filter :assign_subjects
  before_filter :assign_places
  before_filter :require_login, :only => [:change_password, :logout, :change_status, :profile, :edit_profile], :if => lambda { |x| 
    (x.params[:action] == 'change_password' && !x.params[:recover]) || [:logout, :change_status, :edit_profile].map(&:to_s).include?(x.params[:action]) 
  }

  def register

    if request.post?
      @user = TypusUser.new(params[:typus_user].merge(:role => 'user'))
      @user.generate_activation_code

      if @user.valid_with_captcha? && @user.save
        Notifier.deliver_activation_notification(@user)
        flash[:notice] = 'Успешно зарегистрировались, на Ваш email отправлено письмо, пожалуйста следуйте инструкциям в письме'
        redirect_to root_url
      end
    else
      @user = TypusUser.new
    end
  end
  
  def activate
    @user = TypusUser.find_by_activation_code params[:code]

    if @user
      Notifier.deliver_register_notification(@user)
      @user.make_activated
    end
  end

  def login
    @user = TypusUser.new

    if request.post?
      @auth_user = TypusUser.authenticate_by_login_and_password(params[:typus_user][:login], params[:typus_user][:password])

      if @auth_user
        unless @auth_user.activated?
          flash[:notice] = render_to_string '/require_activation'
          return redirect_to :back if request.env['HTTP_REFERER']
          return redirect_to root_url
        end

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

  def profile
    @user = TypusUser.find(params[:id])
  end

  def change_status
    if params[:status]
      if @current_user.role == 'user'
        @current_user.update_attributes :role => 'partner'
      else
        @current_user.update_attributes :role => params[:status] == 'partner' ? 'partner' : 'master'
      end

      redirect_to change_status_path
    end
  end

  def edit_profile


    if params[:typus_user]

      begin
        @birth_date = params[:typus_user][:birth_date] = parse_date(params[:typus_user][:birth_date])
      rescue 
      end

      if @current_user.update_attributes(params[:typus_user])
        flash[:notice] = 'Информация успешно отредактирована'
      else
      end
    end

    @item = @current_user

    if @item.place && @item.place.parent
      @root_place_id = @item.place.parent.id
      @place_id = @item.place.id
      @child_places = @item.place.parent.children.collect { |p| [p.title, p.id] }
    end
  end

  def masters
    @users = TypusUser.masters(params[:page])
  end
end
