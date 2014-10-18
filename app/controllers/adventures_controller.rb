class AdventuresController < ApplicationController
  def new
    @adventure = Adventure.new
    gon.push adventure: @adventure
    render action: 'edit'
  end

  def show
    gon.push adventure: Adventure.find(params[:id])
  end

  private

  def adventure_params
    params.require(:adventure).permit(:name, :description, :game_type, :content)
  end
end
