class Topic < Type
  attr_reader :id, :group_id, :vk

  def self.get_valid(group_id, data)
    messages = []
    topics = new(group_id: group_id).objects(topic_counts: 30)
    topics.each do |topic|
      Comment.get_valid(group_id, topic, :topic_comments, data).each { |item| messages << item }
    end
    messages
  end

  def initialize(params = {})
    super
    @group_id = params[:group_id]
  end

  # get topics
  def objects(params = {})
    sleep(REQUESTS_INTERVAL)
    begin
      return @vk.board.get_topics(access_token: token,
                                  group_id: @group_id,
                                  count: params[:topic_counts])['items']
    rescue VkontakteApi::Error => e
      puts e
      return []
    end
  end
end
