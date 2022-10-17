class LecturesController < ApplicationController
  def index
    @lectures = Lecture.order(duration: :desc)
    render :index, status: :ok
  end
  
  def create
    @durationConverted = 0

    if lecture_params[:duration] == "lightning"
      @durationConverted = 5
    elsif lecture_params[:duration].is_a? Numeric
      @durationConverted = lecture_params[:duration] 
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

  def show_tracks
    @lectures = Lecture.order(duration: :desc)
    @tracks = generate_tracks(@lectures)
    @tracks = organize_tracks(@tracks)
    render :tracks, status: :ok
  end

  def import
    @file = params[:file].tempfile.read
    @data = JSON.parse(@file)

    for presentation in @data["presentations"] do
      @durationConverted = 0

      if presentation["duration"] == "lightning"
        @durationConverted = 5
      elsif presentation["duration"].is_a? Numeric
        @durationConverted = presentation["duration"]
      else
        @durationConverted = presentation["duration"].split("min")[0]
      end

      @lecture = Lecture.new({
        name: presentation["name"],
        duration: @durationConverted
      })
      @lecture.save
    end

    @lectures = Lecture.order(duration: :desc)

    @tracks = generate_tracks(@lectures)
    @tracks = organize_tracks(@tracks)

    render :tracks, status: :ok
  end
  
  

  private

  def lecture_params
    params.require(:lecture).permit(:name, :duration)
  end

  def valid_float?
    true if Float self rescue false
  end

  # Track relateded methods

  def generate_tracks (lectures)

    tracks = []

    lectures_to_assign = []
    lectures_to_assign.replace(lectures)

    newTrack = []

    newTrack_morning = []
    newTrack_morning_limit = 180
    newTrack_evening =  []
    newTrack_evening_limit =  240

    while lectures_to_assign.length() != 0

      lectures_to_assign = fill_schedule(lectures_to_assign, newTrack_morning, newTrack_morning_limit)

      lectures_to_assign = fill_schedule(lectures_to_assign, newTrack_evening, newTrack_evening_limit)
  
      tracks.push([newTrack_morning, newTrack_evening])
  
      newTrack_morning = []
      newTrack_morning_limit = 180
      newTrack_evening =  []
      newTrack_evening_limit =  240

    end

    return tracks
  end

  def fill_schedule(remaining_lectures, schedule_to_fill, schedule_limit)
    lectures_to_return = []

    for lecture in remaining_lectures do

      if lecture.duration <= schedule_limit

        schedule_limit -= lecture.duration
        schedule_to_fill.push(lecture)
      
      else
        lectures_to_return.push(lecture)
      end
    end

    return lectures_to_return
  end

  def organize_tracks(tracks)
    tracks_organized = []

    for track in tracks do
      organized_track = []
      start_time = '9:00 am'.to_time

      for lecture in track[0] do
        end_time = start_time + lecture.duration.minutes
        organized_lect = {"name" => lecture.name, "duration" => "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"}
        start_time = end_time
        organized_track.push(organized_lect)
      end

      start_time = '1:00 pm'.to_time
      for lecture in track[1] do
        end_time = start_time + lecture.duration.minutes
        organized_lect = {"name" => lecture.name, "duration" => "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"}
        start_time = end_time
        organized_track.push(organized_lect)

        if lecture == track[1][-1]
          min_time = "4:oo pm".to_time

          if start_time.to_i <=min_time.to_i
            start_time  = "4:oo pm".to_time
          end
          
          organized_track.push("name" => "Networking", "duration" => "#{start_time.strftime('%H:%M')}")
        end
      end

      if track[1].length() == 0
        organized_track.push("name" => "Networking", "duration" => "16:00")
      end

      tracks_organized.push(organized_track)
      

    end
    
    return tracks_organized

  end
  
  
  
end
