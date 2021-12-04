class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      #Когда пользователя удалось сохранить мыможем его впустить. Значит поставить признак для пользователя говорящий что вот он зареогистрирован и вошел в систему
      #ставим идентификатор пользователя в сессию
      #ссесия хитрое хранилище, в которое пользотваель не может влезть, и они действуеют ограничено, когда юзер закрыл бразуер они очистились
      session[:user_id] = @user.id
      #Не просто имя а задекорированные имя, то есть вызывае метод из application_controoler
      flash[:success] = "Welcome to the app, #{current_user.name_or_email}"
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end