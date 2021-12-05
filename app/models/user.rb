class User < ApplicationRecord
  #attr нужен чтобы создать виртуальный атрибут, который в бд не попадает, чтоб существовал на обьтекет юзер сущестсовал этот метод и с помощзью которого мы будем отрисовывать текстовое поле и дальше проверять значение его
  attr_accessor :old_password

  #код ниже из гема bcrypt, который хеширует пароль и добавляет два вирутальных метода для пароля, которые не видны в таблицы, но их можно вызыать на образце класса.
  #эти атрибуты будут нужны чтоб пользователь на страничке формы мог ввести пароль, потом его используем и в базу попадет только password_digest
  #false все валидации выключаем и сами пишеи их
  has_secure_password validations: false

  #Запускать валидацию(Проверять старый пароль) только при обовлении записи и только в том случае если пароль новый был указан, если не указан был то игнорируем валидацию, значит пользователь парольменять не ъочет
  validate :corrent_old_password, on: :update, if: -> { password.present? }

  #валидация что поле пароля может быть пустым только при редактировании, в остальных случаях должно быть заполнено
  validate :password_presence

  #пароль долджен быть подтвережден, confirmation: true это встроенная валилдация, кототорая будеь проверять что  наш password имеет такое же значение как другое поле с названиваем password_cinfirmation(просто повторение пароля)
  #allow_blank при обновлении учетной записи пользователь может не захотеть менять пароль, оставить пустым
  validates :password, confirmation: true, allow_blank: true,
    length: {minimum: 8, maximum: 70}
 
  #uniqueness чтобыне было одинаковых майлов, эти проверки на уровне кода, то есть они не сработают если писать запрос в бд анпрямую. НО в db где пишем там уже серрьзгные проверки
  #'valid_email_2/email': true это из гема valid_email2. Проверяет корректный имайл
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true

  #эту валидацию берем с сайта devise? она проверяет пароль на сложность
  validate :password_complexity
    
  private

  def password_presence
    #нужно добавить для пароля сообщение что он пустой с помощью :blank, но не в том случае если password_digest был уже указан, что пользователь пароль какойто задал раньше, и пароль значитможно и указыватьи не укеазывать
    errors.add(:password, :blank) unless password_digest.present?
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    # если пароль пустой или имеет достаточную сложность то нормально, если нет ошибка добаляется
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
  
    errors.add :password, 'сomplexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def corrent_old_password
    #вызовем методы Bcrypt няпрямую .password_digest_was - метод rails создается автоматически, was говорит что нужно вытащить именно старый digest а не новый который хрнаится в памяти
    #и провреим(сделаем digest на основе старого(который ввели) пароля) и сравним с тем что хрнаится в бд (digest который в бд)
    #если digest совпали то старый пароль введен верно
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'

  end
end
