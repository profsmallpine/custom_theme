# Custom Theme Demo w/Multi-Tenancy (scopes)
The purpose of this demo is to show how to use a sass variables file to control theming that the user can edit and see the results immediately. The sass variables file draws from the database, and the cache is cleared upon adding a new theme color so that the new results are compiled.

There is also the added problem of separating sass files from one store to another. This was solved by linking to a dynamic stylesheet_link_tag in the layout (requiring a separate sass application file for each subdomain) and by adding the following for each subdomain in config:

```ruby
Rails.application.config.assets.precompile += %w( spruce_application.css )
Rails.application.config.assets.precompile += %w( professor_application.css )
```

## Preview theme before saving
In order to allow the user to preview their changes, [IMGKit](https://github.com/csquared/IMGKit) was used to take a snapshot of the html page. In order to give the page its custom css, the master sass file was given an erb extension and passed an instance variable. Then it was compiled to sass, and then sass into css. This compiled css file was saved and then passed in to the html snapshot. Once the file was saved, it could then be previewed by the user before saving their changes.
