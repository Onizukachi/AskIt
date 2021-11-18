module ErrorHandling
  #делаем extend данного модуля ActiveSupport::Concern

  extend ActiveSupport::Concern

  #и когда этот errorhandling включается в какойто-то класс, то необходимо добавить методы снизу в тот класс, к которому этот модуль был подключен
  included do
    #rescue обрабатывать ошибку которая называется ActiveRecord::RecordNotFound и обрабатывать ее стоит в методе
    #который называется not_found(который мы создали ниже)
    rescue_from ActiveRecord::RecordNotFound, with: :notfound

    private

    def notfound(exeption)
      #exeption - принимаем ту ошибку которая произошла
      #logger записывает в журнал событий эту ошибку
      logger.warn exeption
      #выдавать файл 404.html (который автоматом сгенерирован ror), layout: false - выдавать файд сам по себе безо всяких layout
      #файлы живущиен в public не обрабатываются ror а сразу отдаются пользователю
      #В качестве статуса мы говорим not_found
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end
end