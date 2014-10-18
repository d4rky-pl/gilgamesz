class AdventuresController < ApplicationController

  def index
    @adventures = Adventure.paginate(page: params[:page], per_page: 9)
    @played_adventures = Adventure.paginate(page: params[:page], per_page: 9).limit(9)
    @best_adventures = Adventure.all.order('plays DESC').limit(9)
  end

  def new
    @adventure = Adventure.new
    set_gon_attributes
    render action: 'edit'
  end

  def edit
    @adventure = Adventure.find(params[:id])
    set_gon_attributes
  end

  def show
    @adventure = Adventure.find(params[:id])
    @adventure.increment! :plays
    gon.push adventure: @adventure.content
  end

  private

  def set_gon_attributes
    gon.push adventure: @adventure.content, available_images: available_images
  end

  def adventure_params
    params.require(:adventure).permit(:name, :description, :game_type, :content)
  end

  def available_images
    Dir.chdir(Rails.root.join('app','assets','images','items')) { Dir["*.*"] }
  end
end
