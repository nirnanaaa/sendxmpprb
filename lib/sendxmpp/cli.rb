require 'thor'
require 'inifile'

module Sendxmpp

  # Class CLI
  #
  # Input via STDIN or -m option:
  #
  # Examples
  #   sendxmpprb -m "server down notification" user mosny@jabber.org
  #   echo "server down"|sendxmpprb user mosny@jabber.org
  #   ...
  #
  class CLI < Thor

    class_option :server, default: "", type: :string, aliases: "-s", required: false
    class_option :port, default: 5222, type: :numeric, aliases: "-p", required: false
    class_option :tls, default: true, type: :boolean, aliases: "-t", required: false
    class_option :tls_verify_peer, default: true, type: :boolean, required: false
    class_option :tls_ca, default: "", type: :string, required: false
    class_option :resource, default: "Sendxmpp", type: :string, required: false
    class_option :password, default: "", type: :string, required: false
    class_option :jid, default: "", type: :string, required: false
    class_option :config, default: "#{ENV['HOME']}/.sendxmpprbrc", type: :string, aliases: "-c", required: false
    class_option :logfile, default: nil, aliases: '-l', required: false

    # Public: configuration options
    attr_reader :config

    # Public: logger
    attr_reader :log

    # Public: Initialize a new Object from CLI
    #
    # args - Arguments, passed to Thor
    #
    # Raises IniFile::Error on invalid configuration
    def initialize(*args)
      super
      if File.exists?(options[:config])
        @config = IniFile.load(options[:config])["sendxmpp"]
        local_conf = options.dup
        @config.merge!(local_conf)
      end
      if config["logfile"]
        @log = Logger.new(config["logfile"])
      else
        @log = Logger.new(STDOUT)
      end
      log.level = config["loglevel"].to_i || 2
      log.debug("finished loading configuration.")
      $stdout.sync = true
    end

    desc "user [USER1],[USER2],...", "send a message to jabber users"
    # Public: Send a message to multiple users.
    #         Message will be sent to each user seperately
    #
    # jids - Receipient(s) can be one or more
    #
    # Examples
    #   user(["mosny@jabber.org"])
    #   user(["mosny@jabber.org", "someone@jabber.org"])
    #   ...
    #
    # Returns 0 or 1 exit codes
    def user(jids)
      log.debug("Received call for user method")
    end

    desc "chat [CHAT1],[CHAT2],...", "send a message to multiple multi user chats"
    # Public: Send a message to a single/multiple multi user chatrooms.
    #         Messages will be sent to each chat seperately
    #
    # rooms - Array of MUC(Multi user chat) jids.
    #
    # Examples
    #   chat(["edv@conference.jabber.org"])
    #   chat(["edv@conference.jabber.org", "staff@conference.jabber.org"])
    #
    # Returns 0 or 1 exit codes
    def chat(rooms)
      log.debug("Received call for chat method")
    end

  end
end
