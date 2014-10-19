class ImagesController < ApplicationController

  def create
    @image = Image.create
    @image.file = params[:image][:file]
    if @image.save
      render json: { message: "success", image_path: @image.file.url }, :status => 200
    else
      render json: { error: @image.errors.full_messages.join(',')}, :status => 400
    end
  end

end