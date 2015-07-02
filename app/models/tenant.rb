class Tenant < ActiveRecord::Base
  include RailsSettings::Extend
  cattr_accessor :current_id

  has_one :theme

  def self.current_id=(id)
    Thread.current[:tenant_id] = id
  end

  def self.current_id
    Thread.current[:tenant_id]
  end
end
