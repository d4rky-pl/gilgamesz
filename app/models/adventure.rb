class Adventure < ActiveRecord::Base
  enum game_type: %w( fantasy sci-fi detective )

  EMPTY_JSON = {
      nodes: [
                {
                    id: 'root',
                    type: 'passage',
                    name: 'First Room',
                    description: 'This is where your story goes. You can write anything you would like.',
                    actions: []
                }
             ],
      items: [],
      settings: {
                 name:        'Your Own Game',
                 description: '',
                 game_type:   'fantasy'
             }
  }

  before_create :generate_token
  before_save :content_will_change!

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
