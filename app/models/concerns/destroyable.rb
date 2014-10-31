module Destroyable

  extend ActiveSupport::Concern

  def destroy
    raise "#{self.class} cannot be destroyed"
  end

  def delete
    raise "#{self.class} cannot be deleted"
  end

  module ClassMethods

    def destroy_all
      raise "#{self} cannot be destroyed"
    end

    def delete_all
      raise "#{self} cannot be deleted"
    end
  end

end