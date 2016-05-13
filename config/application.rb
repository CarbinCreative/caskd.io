require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Caskd
  class Application < Rails::Application

    config.encoding = 'utf-8'
    config.time_zone = 'Europe/Stockholm'
    config.filter_parameters += [:password]

    config.i18n.fallbacks = [:en]
    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.autoload_paths += %W(#{config.root}/lib/)
    config.autoload_paths += %W(#{config.root}/lib/validators/)

    config.generators.stylesheets = false
    config.generators.javascripts = false

    config.assets.enabled = false
    config.serve_static_files = true

    config.active_record.raise_in_transactional_callbacks = true

    Haml::Template.options[:format] = :html5
    Haml::Template.options[:attr_wrapper] = '"'
    Haml::Template.options[:hyphenate_data_attrs] = true

    config.before_configuration do
      env_file = File.join Rails.root, 'config', 'env.yml'
      YAML.load(File.open env_file).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

  end
end
