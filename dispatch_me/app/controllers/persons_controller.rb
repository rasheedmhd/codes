class PersonsController < ApplicationController
  def index
    @persons = Person.all 
    render stream: true
  end

  def new
  end

  def create
  end

  def update
  end

  def edit
  end
end
