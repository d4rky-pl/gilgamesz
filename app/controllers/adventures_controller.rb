class AdventuresController < ApplicationController

  def new
    @adventure = Adventure.new
    render action: 'edit'
    set_gon_attributes
  end

  def edit
    @adventure = Adventure.find(params[:id])
    set_gon_attributes
  end

  def show
    gon.push adventure: Adventure.find(params[:id])
  end

  private

  def set_gon_attributes
    gon.push game_types: Adventure.game_types.keys, adventure: @adventure.content
  end

  def adventure_params
    params.require(:adventure).permit(:name, :description, :game_type, :content)
  end
end
