class ApplicationController < ActionController::Base 
 #этот родительский контроллер от него все наследуют другие контроллеры
  
 #Делаем инклуд специальеых методов для разбивки странц(Для бэкенда)
  include Pagy::Backend
  
  #Поключаем модуль из concerns
  include ErrorHandling

  #еще один модуль
  include Authentication

end
