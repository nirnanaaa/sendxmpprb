require 'xmpp4r/client'
module Sendxmpp

  # Public: Message class
  #
  # requires an initialized Config class.
  #
  class Message
    include Config
    include ::Jabber

    # Public: Getter for the batch status
    attr_reader :batch

    # Public: Getter / Setter for the jabber client
    attr_accessor :client

    # Public: Getter for receipients
    #
    # Returns an Array
    def receipients
      @receipients ||= []
    end

    # Public: Initializer
    #
    #
    def initialize
      @batch=false
      if config.jid.nil? || config.jid.empty?
        Log.logger.error("JID is not defined.")
        Log.logger.error("Please use the -j option or the directive jid=... in .sendxmpprbrc")
        exit 1
      end
      jid = JID.new(config.jid)
      Log.logger.debug("Initializing a new Jabber client instance.")
      self.client = Client.new(jid)
      Log.logger.debug("Initialized a new Jabber client instance.")
      Log.logger.debug("Connecting to Jabber server.")
      client.connect(config.server, config.port)
      Log.logger.debug("Connected to Jabber server.")
      Log.logger.debug("Authenticating with Jabber server.")
      client.auth(config.password)
      Log.logger.debug("Authenticating with Jabber server.")
    rescue Jabber::ClientAuthenticationFailure => e
      Log.logger.error("Authentication error for jid %s" % config.jid)
      exit 1
    rescue SocketError => e
      Log.logger.error("There was an error connecting to the server: %s" % e.message)
      exit 1
    end

    # Public: Singleton object getter
    def self.myself
      @self ||= self.new
    end

    # Public: Batch relay
    def self.batch(&block)
      myself.process_batch(&block)
    end

    # Public: Send a message to a user
    #
    # user - Receipient
    #
    def self.message_to_user(user)
      myself.message(type: :user, user: user)
    end

    # Public: Send a message to a chatroom
    #
    # room - Room to send message to
    #
    def self.message_to_room(room)
      myself.message(type: :group, user: room)
    end

    # Public: Split a special formatted JID into the following
    #         parts:
    #         JID - normal XMPP JID
    #         Password - XMPP room password
    #
    # user - JID to split up
    #
    # Returns an Array of 2 elements
    def split_password(user)
      user.split(":")
    end

    # Public: Send a message
    #
    # options - Message hash options
    #
    # Examples
    #   message(type: :user, user: "jid@server.com")
    #   message(type: :group, user: "jid@conference.server.com:password")
    #
    def message(options)
      return if config.message.empty?
      if batch == true
        receipients << options
      else
        if options[:type] == :user
          send_message(config.message, options[:user])
        else
          group, password = split_password(options[:user])
          send_muc_message(config.message, group, password)
        end
      end
    end

    # Public: Enables batch procession for this session
    #
    # block - Block to execute as a batch
    #
    # Returns false
    def process_batch(&block)
      Log.logger.info("Batch procession started.")
      unless block_given?
        Log.logger.error("Please specify a block to use this function.")
        exit 1
      end
      @batch=true
      yield
      send_batch
      @batch=false
    end

    # Public: Send a message to a single user
    #
    # user - JID of the receipient
    #
    # Returns nothing
    def send_message(user)
      Log.logger.debug("sending message to user %s" % user)
      m = Jabber::Message.new(user, generate_message)
      client.send(m)
      Log.logger.debug("sent message")
    end

    # Public: Send a message to a MUC (Multi User Chat)
    #
    # room - Room to send the message to
    # password - Password for the chatroom if required
    #
    # Returns nothing
    def send_muc_message(room, password=nil)
      Log.logger.debug("including file xmpp4r/muc")
      require 'xmpp4r/muc'
      m = Jabber::Message.new(room, generate_message)
      muc = MUC::MUCClient.new(client)
      if !muc.active?
        Log.logger.info("Joining room %s" % room)
        muc.join(JID.new(room + '/' + config.resource), password)
        Log.logger.info("Joined room %s" % room)
      end
      muc.send m
    end

    # Public: Send the batch out
    def send_batch
      receipients.flatten.each do |rcpt|
        user, password = split_password(rcpt[:user])
        if rcpt[:type] == :user
          send_message(user)
        elsif rcpt[:type] == :group
          send_muc_message(user, password)
        end
        Log.logger.debug("Removing item %p from queue" % rcpt)
        receipients.delete(rcpt)
      end
    end

    private

    # Private: Generates a message for sending. Combines subject and message
    #
    # Returns the message string
    def generate_message
      if config.subject
        msg = ""
        msg << "\n"
        msg << "-----------------------------------------\n"
        msg << "New Message:\n"
        msg << "%s\n" % config.subject
        msg << config.message
        msg << "\n-----------------------------------------\n"
        msg
      else
        config.message
      end

    end
  end
end
