class AdventureValidator
  class NameTaken < StandardError; end
  class InvalidPassage < StandardError; end
  class InvalidGameType < StandardError; end

  def initialize(json)
    @json = json
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def validate!
    validate_unique_name!
    validate_passages!
    true
  end

  protected
  def settings
    @json['settings']
  end
  
  def nodes
    @json['nodes']
  end

  def items
    @json['items']
  end
  
  def validate_unique_name!
    raise NameTaken unless Adventure.where("content->'settings'->>'name' = ?", settings['name']).count == 0
  end
  
  def validate_game_type!
    raise InvalidGameType unless settings['game_type'].in? %w(fantasy scifi detective)
  end

  def validate_passages!
    node_ids = nodes.map { |node| node['id'] }

    nodes.each do |node|
      if node['type'] == 'passage'
        node['actions'].each do |action|
          raise InvalidPassage unless node_ids.include? action['node_id']
        end

      elsif node['type'] == 'add_item' || node['type'] == 'use_item'
        node['events'].values.each do |event|
          event['actions'].each do |action|
            raise InvalidPassage unless node_ids.include? action['node_id']
          end
        end
      end
    end
  end

  def validate_items!
    item_ids = items.map { |item| item['id'] }

    nodes.each do |node|
      if node['item_id'].present?

      end
    end
  end

end