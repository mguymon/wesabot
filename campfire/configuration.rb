module Campfire
  class ConfigurationError < RuntimeError; end

  class Configuration
    protected

    def initialize(data={})
      load data
    end

    def load(data)
      data = data.inject({}) {|h,(k,v)| h[k.to_sym] = v; h }
      self.api_token = data[:api_token]
      self.subdomain = data[:subdomain]
      self.room      = data[:room]
      self.verbose   = data[:verbose] || false
      self.ssl       = data[:ssl] || false
    end

    public

    attr_accessor :api_token, :subdomain, :room, :verbose, :ssl

    alias_method :verbose?, :verbose
    alias_method :ssl?, :ssl

    def validate!
      api_token or raise ConfigurationError, 'no api token given'
      subdomain or raise ConfigurationError, 'no subdomain given'
      room      or raise ConfigurationError, 'no room given'
    end

    def reload!
    end
  end

  class FileConfiguration < Configuration
    protected

    attr_reader :path

    def initialize(path)
      @path = path
      reload!
    end

    public

    def reload!
      load YAML.load_file(path)
    end
  end
end