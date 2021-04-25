class Group < Type
  attr_reader :id, :vk, :token

  def self.message_none_posts(id)
    {
      type: 'Не получены посты группы',
      url: "https://vk.com/public#{Group.new.surname(id)[0]['id']}",
      keywords: []
    }
  end

  def initialize
    super
  end

  # alternative name for group VK
  def surname(id)
    sleep(REQUESTS_INTERVAL)
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
    sleep(REQUESTS_INTERVAL)
    filter(@vk.groups.getById(group_ids: group_names, fields: 'wall'))
  end
end
