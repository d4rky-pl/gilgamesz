class AdventuresController < ApplicationController
  def new
    @adventure = Adventure.new
    gon.push adventure: @adventure
    render action: 'edit'
  end

  private

  def adventure_params
    params.require(:adventure).permit(:name, :description, :game_type, :content)
  end
end
