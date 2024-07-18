class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy set_admin remove_admin]
  before_action :authenticate_user!, except: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all

    if user_signed_in?
      @created_by_me = current_user.projects
    else
      @created_by_me = []
    end
  end

  def show
  end

  def new
    @project = current_user.projects.build
  end

  def edit
  end

  def create
    @project = current_user.projects.build(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_admin
    user = User.find(params[:user_id])
    user.update(admin: true)
    @message = "Admin privileges granted."
    respond_to do |format|
      format.html { redirect_to project_url(@project), notice: @message }
      format.json { render :show, status: :ok, location: @project }
    end
  end

  def remove_admin
    user = User.find(params[:user_id])
    user.update(admin: false)
    @message = "Admin privileges revoked."
    respond_to do |format|
      format.html { redirect_to project_url(@project), notice: @message }
      format.json { render :show, status: :ok, location: @project }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :add_member, :user_id, :admin)
  end

  def correct_user
    @project = current_user.projects.find_by(id: params[:id])
    redirect_to projects_path, notice: "Sorry! Not Authorized to Edit/Delete this Project because it was not created by you!" if @project.nil?
  end
end
