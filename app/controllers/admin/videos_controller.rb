class Admin::VideosController < AdminsController
 before_action :select_video, only:[:edit,:update,:destroy] 
  def new
    @video = Video.new
    @categories = Category.all
  end

  def create
    @video = Video.new(video_params)
    if @video.save 
      flash["success"] = "Your video was successfully uploaded"
    else
      flash["danger"] = "There was a problem uploading that video"
    end

    redirect_to new_admin_video_path
  end

  def edit
    @categories = Category.all
  end

  def update
    if @video.update(video_params)
      flash["success"] = "Video was successfully edited"
      redirect_to video_path(@video)
    else
      flash.now["danger"] = "There was a problem updating this video"
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_path
  end

  private
  def video_params
    params.require(:video).permit(:title,:description,:category_id,:small_cover,:large_cover,:video_url)
  end

  def select_video
    @video = Video.find_by(slug: params[:id])
  end

end