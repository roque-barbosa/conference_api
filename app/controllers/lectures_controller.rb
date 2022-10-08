class LecturesController < ApplicationController
  def index
    @lectures = Lecture.order(duration: :desc)
    render :index, status: :ok
  end
  
  def create

    @durationConverted = 0
    if lecture_params[:duration] == "lightning"
      @durationConverted = 5
    else
      @durationConverted = lecture_params[:duration].split("min")[0]
    end

    @lecture = Lecture.new({
      name: lecture_params[:name],
      duration: @durationConverted
    })
    if @lecture.save
      render :show, status: :created
    else
      render json: {error: "Error creating lecture"}
    end
  end

  def update
    @lecture = Lecture.find_by(id: params[:id])
    if @lecture
      @lecture.update(
        name: params[:name],
        duration: params[:duration]
      )
      render :show, status: :ok
    else
      render json: {error: "Lecture not found"}
    end
      
  end
  
  
  def destroy
    @lecture = Lecture.find_by(id: params[:id])
    if @lecture.destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  def show
    @lecture = Lecture.find_by(id: params[:id])
    if @lecture
      render json: @lecture, status: :ok
    else
      render json: {error: "Product Not Found."}
    end
    
  end
  

  private

  def lecture_params
    params.require(:lecture).permit(:name, :duration)
  end

end
