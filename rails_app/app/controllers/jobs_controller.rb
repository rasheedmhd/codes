class JobsController < ApplicationController
  def create
    # Fails because we need to explicitly permit and require 
    # parameters
    # Person.create(params[:job])
  end

  def index
  end

  def new
  end

  def edit
  end
  
  private 
    def params 
      job_params.require(:job).permit(:name)
    end
end
