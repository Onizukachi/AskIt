module ApplicationHelper
  #Этот хелпер будет принимать название ссылки, url, и также набор других опций(необязательных, поэтому {}), который представлены в виде хеша, то есть вот это (<%= nav_tab 'Home', root_path, class: 'nav-link px-2' %)
  def nav_tab(title, url, options = {})
    #Вытаскиваем текущую страницу из набора опций
    #находим значение по ключу, удаляем,  и сохраняем начение в перемеенной(delete возвращает значение при удалении ключа)
    current_page = options.delete :current_page

    #теперь нужно понять какой класс CSS неоюходимо назначать ссылке
    # white будет назначаться для всех ссылок, secondary только для текущей ссылки
    #сравниваем, если текущая страница поступившщая в currently_at равна title ссылки, то делаем класс секондари, страница где мы находимся, если нет, то текст вайт
    css_class = current_page == title ? 'text-secondary' : 'text-white'

    #если options[:class] присутствует, то берем этот же класс и добавим к нему наш собственный, если нет класса вовсе, то просто добавим наш класс css
    options[:class] = if options[:class]
                      options[:class] + ' ' + css_class
                        else
                          css_class
                        end
    #Здесь выводим ссылку
    link_to title, url, options
  end
  
  #с помощью этого хелпера выводим не только меню но и говорим на какой странице мы на данный момент мы находимся
  #нужно писать именно partial, потомучто если просто рендер написать он выдаст и паршл и layout, а нам нужен только паршл
  def currently_at(current_page = '')
    #то есть берем значение current_page и уснтанавливаем его в 'shared/menu'
    #locals значит делаем локальную переменную, значение которой будет доставаться из current_page
    render partial: 'shared/menu', locals: {current_page: current_page}
  end
  
  #метод принимает название конкретной страницы, если оно присутсвует, то это название пристыковывалось к ASkIt
  def full_title(page_title = "")
    base_title = "AskIt"
    if page_title.present? #если значение переменной установлено, то выводим нахвания нашей страницы отделенное от базового названия косой чертой
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end
end
