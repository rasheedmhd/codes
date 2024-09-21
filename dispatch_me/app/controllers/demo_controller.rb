class DemoController < ApplicationController
  # layout :demo, only: %i[index show new]
  # layout :demo, except: %i[create upate edit]
  # layout true
  # Rails still understands and works with this, 
  # displaying the index file from app/views/demo

  def clayout
    render layout: false
    # render :index
  end

  def renderrr
    render html: "<strong>Not Found</strong>".html_safe
  end

  def no_t
  end

  def nothing
    # head :ok
    head :unauthorized
  end
end
