require 'test_helper'

class AdventureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: adventures
#
#  id          :integer          not null, primary key
#  content     :json
#  token       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  description :text
#  game_type   :integer
#
