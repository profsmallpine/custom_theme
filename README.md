# Custom Theme Demo w/Multi-Tenancy (scopes)
The purpose of this demo is to show how to use a sass variables file to control theming that the user can edit and see the results immediately. The sass variables file draws from the database, and the cache is cleared upon adding a new theme color so that the new results are compiled.

There is also the added problem of separating sass files from one store to another. This was solved by linking to a dynamic stylesheet_link_tag in the layout (requiring a separate sass application file for each subdomain) and by adding the following for each subdomain in config:

```ruby
Rails.application.config.assets.precompile += %w( spruce_application.css )
Rails.application.config.assets.precompile += %w( professor_application.css )
```
