class DemoController < ApplicationController
  # Rails still understands and works with this, 
  # displaying the index file from app/views/demo
  def renderrr
    render html: "<strong>Not Found</strong>".html_safe
  end
  def no_t
  end
end
