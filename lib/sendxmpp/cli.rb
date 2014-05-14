require 'thor'

module Sendxmpp
  class CLI < Thor

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
    end

  end
end
