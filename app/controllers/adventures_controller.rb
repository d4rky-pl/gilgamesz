class AdventuresController < ApplicationController

  def index
    @adventures = Adventure.paginate(page: params[:page], per_page: 6)
  end

  def new
    @adventure = Adventure.new
    gon.push adventure: @adventure
    render action: 'edit'
  end

  def show
    @adventure = Adventure.find(params[:id])
    @adventure.increment! :plays
    gon.push adventure: @adventure
  end

  private

  def adventure_params
    params.require(:adventure).permit(:name, :description, :game_type, :content)
  end
end
