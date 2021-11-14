Rails.application.routes.draw do
  #resources создает множество маршрутов для 1 контроллера, можно подписать only: %i[index new edit create update destroy show]
  #для questions создать маршруты только методов что в массиве
  #%i перед массивом автоматом ставит запятые между элементами
  #Но мы используем здесь все стандартные 7 мметодов, все что сверху написал, если нужны конкретные
  resources :questions

  root 'pages#index'
end
