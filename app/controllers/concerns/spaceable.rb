module Spaceable
  extend ActiveSupport::Concern

  def spaces
    return @spaces if defined? @spaces

    @spaces = current_user.spaces
  end

  def space
    return @space if defined? @space

    @space = spaces.find(params[:space_id])
  end
end
