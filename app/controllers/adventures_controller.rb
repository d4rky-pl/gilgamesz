class AdventuresController < ApplicationController
  before_action :fluid_layout, only: [:edit, :new]

  def index
    @adventures = Adventure.order('created_at DESC').paginate(page: params[:page], per_page: 9)
    @played_adventures = (session[:played_adventures]) ? Adventure.find(played_adventures)[0..8] : [];
    @best_adventures = Adventure.all.order('plays DESC').limit(9)
    @liked_adventures = liked_adventures
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
    mark_adventure_as_played
  end

  def like
    @adventure = Adventure.find(params[:adventure_id])
    unless liked_adventures.include? params[:adventure_id]
      @adventure.increment! :likes
      mark_adventure_as_liked
    end
  end

  private

  def set_gon_attributes
    gon.push adventure: @adventure.content, available_images: available_images, adventure2: Adventure.find(2).content
  end

  def adventure_params
    params.require(:adventure).permit(:name, :description, :game_type, :content)
  end

  def available_images
    Dir.chdir(Rails.root.join('app','assets','images','items')) { Dir["*.*"] }
  end

  def played_adventures
    session[:played_adventures] ||= []
  end

  def mark_adventure_as_played
    (session[:played_adventures] ||= []) << params[:id]
  end

  def liked_adventures
    session[:liked_adventures] ||= []
  end

  def mark_adventure_as_liked
    (session[:liked_adventures] ||= []) << params[:adventure_id]
  end

  def fluid_layout
    @fluid_layout = true
  end
end
