class Theme < ActiveRecord::Base
  belongs_to :tenant

  default_scope {where(tenant_id: Tenant.current_id)}
end
