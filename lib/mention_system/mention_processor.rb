###
# MentionSystem module
#
# This module defines common behavior in mention system
###
module MentionSystem
  ###
  # MentionProcessor class
  #
  # This class defines mention processor behavior in mention system
  ###
  class MentionProcessor
    ###
    # Constructor of the MentionProcessor class
    ###
    def initialize
      @callbacks = { after: [], before: [] }
    end

    ###
    # Adds an after callback
    #
    # @param [Proc] callback - the callback to add
    ###
    def add_after_callback(callback)
      @callbacks[:after].push(callback)
    end

    ###
    # Adds a before callback
    #
    # @param [Proc] callback - the callback to add
    ###
    def add_before_callback(callback)
      @callbacks[:before].push(callback)
    end

    ###
    # Extract handles from mentioner
    #
    # @param [Mentioner] mentioner - the {Mentioner} to extract handles from
    # @return [Array]
    ###
    def extract_handles_from_mentioner(mentioner)
      content = extract_mentioner_content(mentioner)
      handles = content.scan(handle_regexp).map { |handle| handle.gsub("#{mention_prefix}","") }
    end

    ###
    # Extracts the mentioner content
    #
    # @param [Mentioner] mentioner - the {Mentioner} to extract content from
    # @return [String]
    ###
    def extract_mentioner_content(mentioner)
      raise "Must be implemented in subclass"
    end

    ###
    # Finds mentionees by handles
    #
    # @param [Array] handles - the array of {Mentionee} handles to find
    # @return [Array]
    ###
    def find_mentionees_by_handles(*handles)
      raise "Must be implemented in subclass"
    end

    ###
    # Process mentions
    #
    # @param [Mentioner] mentioner - the {Mentioner} to process mentions from
    ###
    def process_mentions(mentioner)
      mentionees = find_mentionees_by_handles(mentioner)

      mentionees.each do |mentionee|
        if process_before_callbacks(mentioner, mentionee)
          if mentioner.mention(mentionee)
            process_after_callbacks(mentioner, mentionee)
          end
        end
      end
    end

    private
      ###
      # Retrieves the handle regexp
      #
      # @return [Regexp]
      ###
      def handle_regexp
        /(?<!\w)#{mention_prefix}\w+/
      end

      ###
      # Returns the mention prefix
      #
      # @return [String]
      ###
      def mention_prefix
        "@"
      end

      ###
      # Process after callbacks
      #
      # @param [Mentioner] mentioner - the mentioner of the callback
      # @param [Mentionee] mentionee - the mentionee of the callback
      ###
      def process_after_callbacks(mentioner, mentionee)
        result = true
        @callbacks[:after].each do |callback|
          unless callback.call(mentioner, mentionee)
            result = false
            break
          end
        end
        result
      end

      ###
      # Process before callbacks
      #
      # @param [Mentioner] mentioner - the mentioner of the callback
      # @param [Mentionee] mentionee - the mentionee of the callback
      ###
      def process_before_callbacks(mentioner, mentionee)
        result = true
        @callbacks[:before].each do |callback|
          unless callback.call(mentioner, mentionee)
            result = false
            break
          end
        end
        result
      end
  end
end
