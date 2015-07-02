# Custom Theme Demo w/Multi-Tenancy (scopes)
The purpose of this demo is to show how to use a sass variables file to control theming that the user can edit and see the results immediately. The sass variables file draws from the database, and the cache is cleared upon adding a new theme color so that the new results are compiled.

There is also the added problem of separating sass files from one store to another. This was solved by linking to a dynamic stylesheet_link_tag in the layout (requiring a separate sass application file for each subdomain) and by adding the following for each subdomain in config:

```ruby
Rails.application.config.assets.precompile += %w( spruce_application.css )
Rails.application.config.assets.precompile += %w( professor_application.css )
```

## Preview theme before saving
In order to allow the user to preview their changes, [IMGKit](https://github.com/csquared/IMGKit) was used to take a snapshot of the html page. In order to give the page its custom css, the master sass file was given an erb extension and passed an instance variable. Then it was compiled to sass, and then sass into css. This compiled css file was saved and then passed in to the html snapshot. Once the file was saved, it could then be previewed by the user before saving their changes. The basic flow is as follows:

```ruby
# Compile erb to sass and save file
compiled_sass = ERB.new(File.read(File.join(Rails.root, "app", "assets", "stylesheets", "tenants", "#{subdomain}_application.css.sass.erb"))).result(binding)
File.open(File.join(Rails.root, "app", "assets", "stylesheets", "preview", "#{subdomain}_preview.sass"), 'w') { |f| f.write(compiled_sass) }

# Compile sass to css and save file
compiled_css = Sass::Engine.for_file(File.open(File.join(Rails.root, "app", "assets", "stylesheets", "preview", "#{subdomain}_preview.sass")), {
  :cache => false,
  :read_cache => false
}).render
File.open(File.join(Rails.root, "app", "assets", "stylesheets", "preview", "#{subdomain}_preview.css"), 'w') { |f| f.write(compiled_css) }

# Create img from html and pass in compiled css
html = render_to_string(:action => "index.html.erb", :layout => '/layouts/application.html.erb')
@kit = IMGKit.new(html, :quality => 50)
@kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/preview/#{current_tenant.subdomain}_preview.css"
@kit.to_file("#{Rails.root}/app/assets/images/preview/#{current_tenant.subdomain}_preview.jpg")
```

Rather than passing the sass right to the Sass::Engine, it is saved to a file so that the Engine can read it from a file. This is preferable to Sass::Engine.new when reading from a file because it properly sets up the Engine’s metadata, enables parse-tree caching, and infers the syntax from the filename - [see the docs](http://sass-lang.com/documentation/Sass/Engine.html#for_file-class_method).
