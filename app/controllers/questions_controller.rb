class QuestionsController < ApplicationController

    #before говорит что это действие запустится до того как запускается сам экшш
    before_action :set_question!, only: %i[show destroy edit update]

    def show
      #Ниже код чтобы создать ответ к конкретному вопросу
      #В памяти создаем образец класса answer, но при этом сразу привязываем этот ответ к вопросу с помощью даннрой конструкции build
      # ВОТ ЧТО ПОЛУЧАЕТСЯ (q.answers.build => #<Answer id: nil, body: nil, question_id: 10(тут id нашего вопроса), created_at: nil, updated_at: nil)
      @answer = @question.answers.build
      
      #можно найти ответы для вопроса еще так  Answer.where(question_id: @question.id) или кратко (question: @question).order created_at: :desc
       #page разбиваем ответы по 25 по умолчанию, можно изменить в конфиге скок надо, или здесь а конце добавить .per(2), то есть 2 вопроса на странице
       @answers = @question.answers.order(created_at: :desc).page(params[:page])
      #page(params[:page]) разобьет только, а чтобы добавить менюшку для страниц уже во вьюшку добавляем <%= paginate @answers %>
    end
    
    def destroy
        @question.destroy
        #flash это вспышка(поле зеленое с заданным текстом), появялется только для сессии, после перезагрузки исчезает
        flash[:success] = "Question deleated"
        #после удаления делаем редирект на страницу со всеми вопросами
        redirect_to questions_path
    end
    
    #Форму редактирования загружаем
    def edit
    end

    def update
        #edit он форму показывает для редакитирования, а update уже отправляет данные
        #если получилось обновить наш вопрос с новыми параметрами
        if @question.update question_params
          flash[:success] = "Question updated!"
            #redirect перенаправит пользователя на другую страницу(в нашем случае сттраницу всех вопросов)
            redirect_to questions_path
        else
            #Если не сохранил, отрендорить еще раз, представление edit.html.erb
            render :edit
        end
    end
    
    def index
      #вытаскиваем все вопросы и сортируем их, сначала новые. и применяем гем KAMINARI который нужен чтобы разбить записи на страницы
      #чтобы установить сначала добавим в gemfile потом сервер остановить, потьом bundle install, потом копируем конфиругурацию из gita себе, пишем rails g kaminari:config
      #файл находится в config/initialize и там настройки, по дефолту он отображает 25 записей. page разбивает коллекцию по страницам, 
      #rails g kaminari:views default запускаем что загрузить вьюшки и менять спокойно вид, там все изменено как в видео, разобраться надо, пример на сайте бутстрав раздел pagination
      @questions = Question.order(created_at: :desc).page params[:page]
    end

    #new нужен чтобы пользователь открыл эту страницу, увидел интерфейс и опубликовал вопрос
    def new
        #Инстанциурем нашу модель, чтобы пользователь записалданные в нашу бд
        @question = Question.new

    end

    #render значит показать на экране, plain - текст. Params данные которые пришли с запросом
    def create
        @question = Question.new question_params
        if @question.save
            #флеш хранилище которое хранится в сессии, сообщение выдастся 1 раз и после перезагрузки страницы не будет появляться
            flash[:success] = "Question created!"
            #redirect перенаправит пользователя на другую страницу(в нашем случае сттраницу всех вопросов)
            redirect_to questions_path
        else
            #Если не сохранил, отрендорить еще раз, представление new.html.erb
            render :new
        end
    end

    private

    #в присланных параметрах нам нужно require - найти вопрос (question)
    #и достать только title и body. Чобы пользовател не могли внести некорректные данные, например передать id
    def question_params
        params.require(:question).permit(:title, :body)
    end

    def set_question!
       #find by принимает 1 или несколько полей для посика, если не находит, возвращает nil, поэтому ошибка выходит уже во views
        #find тоже ищет по id, но не если не находит, он пишет RecordNotFound, ошибка уже вылетает здесь в контроллере и ее легко перехватить в application_controller
       #[:id] параметр запроса берется из мартшрута
        #params[:id] ПОДСТАВЯЛЕТСЯ ИЗ view нашего вот с этой строки (<%= link_to 'Edit', edit_question_path(question) %>
      @question = Question.find params[:id]
    end
  end