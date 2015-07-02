class Theme < ActiveRecord::Base
  belongs_to :tenant

  default_scope {where(tenant_id: Tenant.current_id)}

  validates_length_of :font_color, maximum: 7

  def self.compile_css_for_preview(subdomain, theme)
    @theme = theme
    compile_erb_to_sass_and_save subdomain
    compile_sass_to_css_and_save subdomain
  end

  def self.return_whitelabel
    Whitelabel.label.some_config
  end

private

  def self.compile_erb_to_sass_and_save(subdomain)
    compiled_sass = ERB.new(File.read(File.join(Rails.root, "app", "assets", "stylesheets", "tenants", "#{subdomain}_application.css.sass.erb"))).result(binding)
    File.open(File.join(Rails.root, "app", "assets", "stylesheets", "preview", "#{subdomain}_preview.sass"), 'w') { |f| f.write(compiled_sass) }
  end

  def self.compile_sass_to_css_and_save(subdomain)
    compiled_css = Sass::Engine.for_file(File.open(File.join(Rails.root, "app", "assets", "stylesheets", "preview", "#{subdomain}_preview.sass")), {
      :cache => false,
      :read_cache => false
    }).render
    File.open(File.join(Rails.root, "app", "assets", "stylesheets", "preview", "#{subdomain}_preview.css"), 'w') { |f| f.write(compiled_css) }
  end
end
