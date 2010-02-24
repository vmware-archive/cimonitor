class PulseController < ApplicationController
  def show
    @projects = Project.where(:enabled => true).order("name").includes(:statuses)
    @projects = @projects.find_tagged_with(params[:tags]) if params[:tags]

    @messages = Message.all
  end
end
