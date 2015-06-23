class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :scope_current_tenant
  before_filter :switch_label

  private

    def switch_label
      unless Whitelabel.label_for(request.subdomains.first)
        redirect_to(labels_url(subdomain: false), alert: "Please select a Label!")
      end
    end

    def current_tenant
      Tenant.find_by_subdomain request.subdomain
    end
    helper_method :current_tenant

    def scope_current_tenant
      Tenant.current_id = current_tenant.id
      yield
    ensure
      Tenant.current_id = nil
    end
end
