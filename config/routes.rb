Rails.application.routes.draw do
  #Создаем ресурс для пользователя
  resources :users, only: %i[new create]
  
  #resources создает множество маршрутов для 1 контроллера, можно подписать only: %i[index new edit create update destroy show]
  #для questions создать маршруты только методов что в массиве
  #%i перед массивом автоматом ставит запятые между элементами
  #Но мы используем здесь все стандартные 7 мметодов, все что сверху написал, если нужны конкретные
  #Это вложенные маршруты, и ответы пока можно только создавать create
  resources :questions do
    #exept - кроме опреденных маршуртов
    resources :answers, except: %i[new show]
  end

  root 'pages#index'
end
