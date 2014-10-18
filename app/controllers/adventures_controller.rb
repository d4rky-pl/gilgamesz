class AdventuresController < ApplicationController
  def new

  end

  private

  def adventure_params
    params.require(:adventure).permit(:content, :token)
  end
end
