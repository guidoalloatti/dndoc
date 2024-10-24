# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w[ admin.js admin.css ]
# Rails.application.config.assets.precompile += %w( controllers/hello_controller.js )
# Rails.application.config.assets.precompile += [/.*\.js/,/.*\.css/]
# Rails.application.config.assets.precompile = ['.js', '.css', '*.css.erb']
Rails.application.config.assets.precompile += %w( application.css )
Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( turbo.min.js )
Rails.application.config.assets.precompile += %w( '*/*.js' )
Rails.application.config.assets.precompile += %w( controllers/create_objects.js )
Rails.application.config.assets.precompile += %w( controllers/index.js )
Rails.application.config.assets.precompile += %w( '*.png' )
# Rails.application.config.assets.check_precompiled_asset = false
