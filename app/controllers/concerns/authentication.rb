module Authentication
  #делаем extend данного модуля ActiveSupport::Concern

  extend ActiveSupport::Concern

  #и когда этот модуль включается в какойто-то класс, то необходимо добавить методы снизу в тот класс, к которому этот модуль был подключен
  included do

    private
    #Метод  узнает кто сейчас в системе работает(Возврашает nil если user_id в сесси вообще нет) 
    #Будем искать пользователя если в сессии есть user_id и декориуем его с помощью decorate(добавляем метод чтоб вместо name если нет поджсаьлялось часть майла).Если его нет, то не ищем
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
  end
  #просто возвращает булево значение,
  def user_signed_in?
    current_user.present?
  end

  #При входе пользователя записываем в сессию его
  def sign_in(user)
    session[:user_id] = user.id
  end

  #удалить информацию из сессии user_id
  def sign_out
    session.delete :user_id
  end
   #Это значтит следующие методы могут работать как хелперы, не только в контроллерах но во вью чтоб доступны были
    helper_method :current_user, :user_signed_in?
    end
  end