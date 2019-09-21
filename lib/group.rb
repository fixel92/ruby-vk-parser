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

  def filter(groups)
    open_wall = []
    groups.select do |group|
      unless group['wall'] == 3
        open_wall << group
      end
    end
    open_wall
  end

  def objects(params = {})
    group_names = []
    params[:urls].each do |url|
      group_names << url.split('/').last
    end
    sleep(1.5)
    filter(@vk.groups.getById(group_ids: group_names, fields: 'wall'))
  end
end
