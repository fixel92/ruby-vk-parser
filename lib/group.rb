class Group < Type
  attr_reader :id, :vk, :token

  def self.message_none_posts(id)
    'Не получены посты группы https://vk.com/public' +
      Group.new.surname(id)[0]['id'].to_s
  end

  def initialize
    super
  end

  # alternative name for group VK
  def surname(id)
    sleep(1.5)
    @vk.groups.getById(group_id: id)
  end

  # filter group with opened wall
  def filter(groups)
    open_wall = []
    groups.select do |group|
      open_wall << group unless group['wall'] == 3
    end
    open_wall
  end

  # get groups
  def objects(params = {})
    group_names = []
    params[:urls].each do |url|
      group_names << url.split('/').last
    end
    sleep(1.5)
    filter(@vk.groups.getById(group_ids: group_names, fields: 'wall'))
  end
end
