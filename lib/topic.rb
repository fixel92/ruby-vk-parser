class Topic < Type
  attr_reader :id, :group_id, :vk

  def initialize(params = {})
    super
    @group_id = params[:group_id]
  end

  # get topics
  def objects(params = {})
    sleep(1)
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
