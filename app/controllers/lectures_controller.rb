class LecturesController < ApplicationController
  def index
    @lectures = Lecture.all
    render json: @lectures, status: :ok
  end
  
  def create
    @lecture = Lecture.new({
      name: lecture_params[:name],
      duration: lecture_params[:duration]
    })
    if @lecture.save
      render json: @lecture, status: :created
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
      render json: @lecture, status: :ok
    else
      render json: {error: "Lecture not find"}
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
