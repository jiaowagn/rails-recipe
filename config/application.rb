require_relative 'boot'

require 'rails/all'

require 'carrierwave'
require 'carrierwave/orm/activerecord'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsRecipes
  class Application < Rails::Application
    config.i18n.default_locale = "zh-CN"
    config.time_zone = "Beijing"
    config.action_view.sanitized_allowed_tags = Rails::Html::WhiteListSanitizer.allowed_tags + %w(table tr td)
    config.action_view.sanitized_allowed_attributes = Rails::Html::WhiteListSanitizer.allowed_attributes + %w(style border)
    Time::DATE_FORMATS.merge!(:default => '%Y/%m/%d %I:%M %p', :ymd => '%Y%m%d')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
