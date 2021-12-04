class UserDecorator < Draper::Decorator
  #строка ниже нужна чтобы делигировать неизвестные методы самому обьекту который мы декодируем
  delegate_all

  def name_or_email
    return name if name.present?

    #если имени нет берем из майла текст до @
    email.split('@')[0]
  end
end

#Декоратоа мы обьявили дальшще задекорриуем наш обьект в application_controller
