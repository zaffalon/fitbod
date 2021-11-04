class WorkoutsController < ApiController
  before_action :authenticate
  load_and_authorize_resource(class: Workout, id_param: :id, instance_name: :workout)

  def create
    if @workout.save
      render json: @workout, status: :created
    else
      render json: @workout.errors, status: :unprocessable_entity
    end
  end

  def index
    @workouts = @workouts.where("created_at >= :last_updated_at", last_updated_at: params[:last_updated_at]) if params[:last_updated_at]
    render json: @workouts
  end

  def show
    render json: @workout
  end

  def destroy
    if @workout.destroy
      head :no_content
    end
  end

  def update
    if @workout.update(workout_params)
      render json: @workout
    end
  end

  private

  def workout_params
    params.permit(:duration, :workout_at)
  end
end
