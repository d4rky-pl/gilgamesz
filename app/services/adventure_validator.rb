class AdventureValidator
  class NameTaken < StandardError; end
  class InvalidPassage < StandardError; end
  class InvalidGameType < StandardError; end
  class InvalidItem < StandardError; end

  def initialize(adventure, json)
    @adventure = adventure
    @json = JSON.parse(json)
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def validate!
    #validate_unique_name!
    validate_passages!
    validate_items!
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
    if @adventure.new_record?
      raise NameTaken unless Adventure.where("content->'settings'->>'name' = ?", settings['name']).count == 0
    else
      raise NameTaken unless Adventure.where("content->'settings'->>'name' = ? AND id != ?", settings['name'], @adventure.id).count == 0
    end
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
        raise InvalidItem unless item_ids.include? node['item_id']
      end
    end
  end

end