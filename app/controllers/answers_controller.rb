class AnswersController < ApplicationController
  #Здесь важен порядок, сначала нужно найти вопрос, а только потом на основе вопроса найти конкретный ответ
  before_action :set_question!
  before_action :set_answer!, except: :create
  
  def create
    #создаем ответ и привязываем его к вопросу
    @answer = @question.answers.build answer_params

    if @answer.save
      flash[:success] = "Answer created"
      #Делаем редирект на страницу вопроса, и в аргументе передаем вопрос на который хотим сделать редирект(Из @question вытащится id и сделается правильная ссылка)
      #redirect браузер пользователя перенапврялет на другой маршрут и заново обрабатывается вспе и все переменные устанавливаются
      redirect_to question_path(@question)
    else
      #мы хотим отрен дорить представление show, но оно лежит не в этой директории Answers(rails будет искать здесь)
      #show лежит в директории questions, поэтому пишем так
      #При redirect нужно чтоб все переменные были опредены, поэтому определяем здесь @answers как в экшене show
      @answers = @question.answers.order created_at: :desc
      render 'questions/show'
    end
  end

  def edit
  end

  def update
    if @answer.update answer_params
      flash[:success] = 'Answer updated!'
      redirect_to question_path(@question)
      else
        render :edit
    end
  end

    def destroy
      @answer.destroy
      flash[:success] = "Answer deleted!"
      redirect_to question_path(@question)
    end

  private 
  
  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question!
      #прежде чем найти вопрос проверяем, существует ли вообще такой вопрос к которому хотим добавить ответ
      @question = Question.find params[:question_id]
  end

  def set_answer!
    @answer = @question.answers.find params[:id]
  end
end