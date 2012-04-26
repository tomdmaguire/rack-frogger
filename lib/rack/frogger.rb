require 'yaml'

module Rack
  class Frogger
    def initialize app, config_path, logger = nil
      @app = app
      @logger = logger
      config = YAML::load( ::File.open( config_path ) )
      @urls = config['request_path_filter']
      @status_codes = config['status_filter']
      @use_rails_logger = config['use_rails_logger']
      @log_method = config['log_method']
    end

    def call(env)
      request = Rack::Request.new(env)
      status, header, response = @app.call(env)

      url_matches_filter = @urls.include?(request.path) || @urls.empty?
      status_matches_filter = @status_codes.include?(status) || @status_codes.empty?
      log env, request, status, header, response if url_matches_filter && status_matches_filter

      [status, header, response]
    end

    private

    def log(env, request, status, header, response)
      logger = @logger || (@use_rails_logger ? Rails.logger : env['rack.errors'])
      request.body.rewind
      log_method = @log_method || 'info'
      logger.send log_method, <<-LOG
#{Time.now.utc}
  URL: #{request.url}
REQUEST:
#{formatted_request env}
  Body: #{request.body.read}
RESPONSE:
#{formatted_response_header header}
  Status: #{status}
  Body: #{response.body if response.respond_to?(:body)}
LOG
    end

    def formatted_request env
      env.keys.find_all { |k| k =~ /^[A-Z_]+$/ }.map { |k| "  #{k.gsub('_', ' ').gsub('HTTP', '').lstrip.capitalize} : #{env[k]}" }.join "\n"
    end

    def formatted_response_header header
      Utils::HeaderHash.new(header).map { |k,v| "  #{k} : #{v}" }.join "\n"
    end
  end
end
