class WorkoutsController < ApplicationController
  before_action :authenticate
  load_and_authorize_resource(class: Workout, id_param: :id, instance_name: :workout)

  def create
    if @workout.save
      render json: WorkoutSerializer.new(@workout), status: :created
    else
      render json: @workout.errors, status: :unprocessable_entity
    end
  end

  def index
    @workouts = @workouts.where("created_at >= :last_updated_at", last_updated_at: params[:last_updated_at]) if params[:last_updated_at]
    @workouts = @workouts.page(params[:page])
    options = {}
    options[:meta] = { page: @workouts.page(params[:page]).current_page, total: @workouts.page(params[:page]).count }
    render json: WorkoutSerializer.new(@workouts, options)
  end

  def show
    render json: WorkoutSerializer.new(@workout)
  end

  def destroy
    if @workout.destroy
      head :no_content
    end
  end

  def update
    if @workout.update(workout_params)
      render json: WorkoutSerializer.new(@workout)
    end
  end

  private

  def workout_params
    params.permit(:duration, :workout_at)
  end
end
