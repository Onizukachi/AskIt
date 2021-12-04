class Question < ApplicationRecord
  #dependent говорит, что если удаляем question то все зависимые ответы тоже нужно удалить
  has_many :answers, dependent: :destroy
    
  validates :title, presence: true, length: {minimum: 2}
  validates :body, presence: true, length: {minimum: 2}


end
