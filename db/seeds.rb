#Этот файл seeds , нужен чьтобы писать скрипты длля добавления демо данных в ваши приложения. Их можно даже писать в миграции так то

#Faker это гем который нужен для геренации предложений или слов или абзацев чего угодно, подключаем его в gemfile ,остановить сервер и потом bundle install.
#Faker lorem это белеберда типо латыни, будет 5 преложегний плюс 4 рандомных предложения добавить
#Faker Hipster генерирует хиптсерские слова, 3 слова в нашем случае, вариантов куча на сайте
#Генерируем 30 вопросов, и они добавяятся в нашу бд, и следоватенльно в наш сайт
30.times do
title = Faker::Hipster.sentence(word_count: 3)
body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
Question.create title: title, body: body
end

# и чтобы пртменить файл seeds нужно выполнить команду rails db:seed