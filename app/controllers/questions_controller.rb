class QuestionsController < ApplicationController

    #before говорит что это действие запустится до того как запускается сам экшш
    before_action :set_question!, only: %i[show destroy edit update]

    def show
      #Ниже код чтобы создать ответ к конкретному вопросу
      #В памяти создаем образец класса answer, но при этом сразу привязываем этот ответ к вопросу с помощью даннрой конструкции build
      # ВОТ ЧТО ПОЛУЧАЕТСЯ (q.answers.build => #<Answer id: nil, body: nil, question_id: 10(тут id нашего вопроса), created_at: nil, updated_at: nil)
      @question = @question.decorate
      @answer = @question.answers.build
      
      #Делаем разбивку по страницам с помощью гема page 
       @pagy, @answers = pagy @question.answers.order(created_at: :desc)
       #и снизу декорируем всю коллекцию ответов
       @answers = @answers.decorate
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
      #Делдаем разбивку страниц и включаем кнопки для переключения
      #дописыыаем @pagy потомучто метод вернет массив состоящий из двух элементов. Он выдаст вопросы которые уже разбиты по страницам
      @pagy, @questions = pagy Question.order(created_at: :desc)
      #Декорируем коллекцию, нельзя сверху дописать, они конфликтьуют с pagy
      @questions = @questions.decorate
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