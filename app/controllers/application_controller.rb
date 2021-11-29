class ApplicationController < ActionController::Base 
 #этот родительский контроллер от него все наследуют другие контроллеры
  
 #Делаем инклуд специальеых методов для разбивки странц(Для бэкенда)
  include Pagy::Backend
  
  #Поключаем модуль из concerns
  include ErrorHandling

  private

    #Метод  узнает кто сейчас в системе работает(Возврашает nil если user_id в сесси вообще нет) Будем искать пользователя если в сессии есть user_id. Еслди его нет, то не ищем
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
  end
  #просто возвращает булево значение,
  def user_signed_in?
    current_user.present?
  end
  
   #Это значтит следующие методы могут работать как хелперы, не только в контроллерах но во вью чтоб доступны были
    helper_method :current_user, :user_signed_in?
end
