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
    include Config

    class_option :server, default: "", type: :string, aliases: "-s", required: false
    class_option :port, default: 5222, type: :numeric, aliases: "-p", required: false
    class_option :tls, default: true, type: :boolean, aliases: "-t", required: false
    class_option :tls_verify_peer, default: true, type: :boolean, required: false
    class_option :tls_ca, default: "", type: :string, required: false
    class_option :resource, default: "Sendxmpp", type: :string, required: false
    class_option :password, default: "", type: :string, required: false
    class_option :message, default: "", type: :string, aliases: '-m', required: false
    class_option :jid, default: "", type: :string, required: false, aliases: '-j'
    class_option :config, default: "#{ENV['HOME']}/.sendxmpprbrc", type: :string, aliases: "-c", required: false
    class_option :logfile, default: nil, aliases: '-l', required: false


    # Public: Initialize a new Object from CLI
    #
    # args - Arguments, passed to Thor
    #
    # Raises IniFile::Error on invalid configuration
    # Raises ArgumentError if the main hash key was not found
    def initialize(*args)
      super
      local_conf = options.dup
      local_conf.delete_if{|k,v|v.nil?||(v.kind_of?(String) && v.empty?)}
      update_config(local_conf)
      if File.exists?(options[:config])
        conf = IniFile.load(options[:config])["sendxmpp"]
        if conf.nil? || conf.empty?
          raise ArgumentError, "No [sendxmpp] section in ini file found!"
        end
      conf.merge!(local_conf)
      update_config(conf)
      end

      Log.logger.debug("finished loading configuration.")
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
    def user(*jids)
      Log.logger.debug("Received call for user method")
      fetch_stdin
      unless jids.kind_of?(Array)
        Log.logger.error("Throwing ArgumentError because Jids is not an array.")
        raise ArgumentError, "Jids needs to be an Array got #{jids.class}"
      end

      if config.message.empty?
        Log.logger.error("No message to send. Exiting.")
        Log.logger.error("See https://github.com/nirnanaaa/sendxmpprb/wiki/Sending-messages for available message formats.")
        exit 1
      end

      Message.batch do
        jids.each do |jid|
          Message.message_to_user(jid)
        end
      end
    end

    desc "chat [CHAT1],[CHAT2],...", "send a message to multiple multi user chats"
    # Public: Send a message to a single/multiple multi user chatrooms.
    #         Messages will be sent to each chat seperately
    #
    # jids - Array of MUC(Multi user chat) jids.
    #
    # Examples
    #   chat(["edv@conference.jabber.org"])
    #   chat(["edv@conference.jabber.org", "staff@conference.jabber.org"])
    #
    # Returns 0 or 1 exit codes
    def chat(*jids)
      Log.logger.debug("Received call for chat method")
      fetch_stdin
      unless jids.kind_of?(Array)
        Log.logger.error("Throwing ArgumentError because Jids is not an array.")
        raise ArgumentError, "Jids needs to be an Array got #{jids.class}"
      end

      if config.message.empty?
        Log.logger.error("No message to send. Exiting.")
        Log.logger.error("See https://github.com/nirnanaaa/sendxmpprb/wiki/Sending-messages for available message formats.")
        exit 1
      end

      Message.batch do
        jids.each do |jid|
          Message.message_to_room(jid)
        end
      end

    end
    no_commands do
      def fetch_stdin
        if !config.message
          Log.logger.info("messages empty. using stdin")
          while $stdin.gets
            config.message ||= ""
            config.message << $_
          end
        end
      end
    end

  end
end
