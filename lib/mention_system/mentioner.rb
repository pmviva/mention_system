###
# MentionSystem module
#
# This module defines common behavior in mention system
###
module MentionSystem
  ###
  # Mentioner module
  #
  # This module defines mentioner behavior in mention system
  ###
  module Mentioner
    ###
    # Extends ActiveSupport::Concern
    ###
    extend ActiveSupport::Concern

    ###
    # Included configuration
    ###
    included do
      ###
      # Has many mentionees association configuration
      ###
      has_many :mentionees, class_name: "MentionSystem::Mention", as: :mentioner, dependent: :destroy
    end

    ###
    # Specifies if self can mention {Mentionee} objects
    #
    # @return [Boolean]
    ###
    def is_mentioner?
      true
    end

    ###
    # Creates a {Mention} relationship between self and a {Mentionee} object
    #
    # @param [Mentionee] mentionee - the mentionee of the {Mention} relationship
    # @return [Boolean]
    ###
    def mention(mentionee)
      Mention.mention(self, mentionee)
    end

    ###
    # Destroys a {Mention} relationship between self and a {Mentionee} object
    #
    # @param [Mentionee] mentionee - the mentionee of the {Mention} relationship
    # @return [Boolean]
    ###
    def unmention(mentionee)
      Mention.unmention(self, mentionee)
    end

    ###
    # Toggles a {Mention} relationship between self and a {Mentionee} object
    #
    # @param [Mentionee] mentionee - the mentionee of the {Mention} relationship
    # @return [Boolean]
    ###
    def toggle_mention(mentionee)
      Mention.toggle_mention(self, mentionee)
    end

    ###
    # Specifies if self mentions a {Mentioner} object
    #
    # @param [Mentionee] mentionee - the {Mentionee} object to test against
    # @return [Boolean]
    ###
    def mentions?(mentionee)
      Mention.mentions?(self, mentionee)
    end

    ###
    # Retrieves a scope of {Mention} objects that are mentioned by self
    #
    # @param [Class] klass - the {Class} to include
    # @return [ActiveRecord::Relation]
    ###
    def mentionees_by(klass)
      Mention.scope_by_mentioner(self).scope_by_mentionee_type(klass)
    end
  end
end

