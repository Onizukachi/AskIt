class QuestionsController < ApplicationController
    #show нужен чтобы выдывать информацию о конкретной записи
    def show
        @question = Question.find_by id: params[:id]
    end
    
    def destroy
        #Удаляем нужный вопрос
        @question = Question.find_by id: params[:id]
        @question.destroy
        flash[:success] = "Question deleated"
        #после удаления делаем редирект на страницу со всеми вопросами
        redirect_to questions_path
    end
    
    #Форму редактирования загружаем
    def edit
        #find by принимает 1 или нессколько полей для посика
        #id: это название того поля в бд по которому делаеся посик, params это обьект со всеми параметрами запроса
        #[:id] параметр запроса берется из мартшрута
        #params[:id] ПОДСТАВЯЛЕТСЯ ИЗ view нашего вот с этой строки (<%= link_to 'Edit', edit_question_path(question) %>
        @question = Question.find_by id: params[:id]
    end

    def update
        #edit он форму показывает для редакитирования, а update уже отправляет данные
        @question = Question.find_by id: params[:id]
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
      @questions = Question.all
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
  end