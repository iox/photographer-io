# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
listen ENV['PORT'], :backlog => Integer(ENV['UNICORN_BACKLOG'] || 200)

timeout 15
preload_app true

before_fork do |server, worker|
  @sidekiq_pid ||= spawn("bundle exec sidekiq -C ./config/sidekiq.yml")
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base) 
      ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  if defined?(ActiveRecord::Base) 
    config = Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']            = ENV['DB_POOL'] || 5
    ActiveRecord::Base.establish_connection(config)
  end

end
