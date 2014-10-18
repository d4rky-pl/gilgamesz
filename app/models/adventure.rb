class Adventure < ActiveRecord::Base
  enum game_type: %w( fantasy sci-fi detective )

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.hex(10)
  end
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
