class ApplicationController < ActionController::Base 
  #этот родительский контроллер от него все наследуют другие контроллеры
  #Поключаем модуль из concerns
  include ErrorHandling
end
