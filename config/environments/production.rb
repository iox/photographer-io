Iso::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Other caching configuration
  config.cache_store = :dalli_store
  config.action_controller.perform_caching = true
  config.action_dispatch.rack_cache = {
    metastore: Dalli::Client.new,
    entitystore: 'file:tmp/cache/rack/body',
    allow_reload: false
  }
  config.static_cache_control = "public, max-age=2592000"

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor  = :uglifier
  # config.assets.css_compressor = :sass

  # Whether to fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = false

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  # config.logger = Logger.new(STDOUT)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  config.assets.precompile += %w( custom.modernizr.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_settings = { api_key: ENV['POSTMARK_API_KEY'] }
  config.action_mailer.default_url_options = { host: ENV['DOMAIN'], locale: "en" }
  config.action_mailer.asset_host = ENV['DOMAIN']

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  if ENV['CDN_HOST'].present?
    config.action_controller.asset_host = ENV['CDN_HOST']
    config.action_mailer.asset_host = ENV['CDN_HOST']
  end

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end

ENV["DATABASE_URL"] = "postgres://yvzstaepnnuswb:tKJm4QkPnb391YRrkZUD0Z3ugW@ec2-50-19-246-223.compute-1.amazonaws.com:5432/depbbrcs0s8v8s"