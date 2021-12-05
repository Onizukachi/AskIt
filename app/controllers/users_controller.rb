class UsersController < ApplicationController
  #скажем что пользовователь не вошел в систему, только в этом случае позволим зарегаться
  before_action :require_no_authentication, only: %i[new create]
  #проверим что пользователь в системе для того чтоб только он мог редактировать профиль
  before_action :require_authentication, only: %i[edit update]

  before_action :set_user!, only: %i[edit update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      #Когда пользователя удалось сохранить мыможем его впустить. Значит поставить признак для пользователя говорящий что вот он зареогистрирован и вошел в систему
      #ставим идентификатор пользователя в сессию, логика в методе в concerns
      #ссесия хитрое хранилище, в которое пользотваель не может влезть, и они действуеют ограничено, когда юзер закрыл бразуер они очистились
      sign_in @user
      #Не просто имя а задекорированные имя, то есть вызывае метод из application_controoler
      flash[:success] = "Welcome to the app, #{current_user.name_or_email}"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update user_params
      flash[:success] = "Your profile was successfully updated!"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :old_password)
  end

  def set_user!
    @user = User.find params[:id]
  end
end