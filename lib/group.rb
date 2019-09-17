require 'vkontakte_api'
require_relative '../config'
require_relative 'type'
require 'pry'

class  Group < Type
  attr_reader :id, :vk, :token

  def initialize
    super
  end

  def surname(id)
    sleep(1.5)
    @vk.groups.getById(group_id: id)
  end

  def objects(params = {})
    group_names = []
    params[:urls].each do |url|
      group_names << url.split('/').last
    end
    sleep(1.5)
    @vk.groups.getById(group_ids: group_names)
  end
end
