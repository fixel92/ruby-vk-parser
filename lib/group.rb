require 'vkontakte_api'
require_relative '../config'
require_relative 'type'
require 'pry'

class  Group < Type
  attr_reader :id, :vk, :token

  def initialize
    super
  end

  def surname(id) # alternative name for group VK
    sleep(1.5)
    @vk.groups.getById(group_id: id)
  end

  def filter(groups) # filter group with opened wall
    open_wall = []
    groups.select do |group|
      unless group['wall'] == 3
        open_wall << group
      end
    end
    open_wall
  end

  def objects(params = {}) # get groups
    group_names = []
    params[:urls].each do |url|
      group_names << url.split('/').last
    end
    sleep(1.5)
    filter(@vk.groups.getById(group_ids: group_names, fields: 'wall'))
  end
end
