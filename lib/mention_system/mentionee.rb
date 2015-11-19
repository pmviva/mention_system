###
# MentionSystem module
#
# This module defines common behavior in mention system
###
module MentionSystem
  ###
  # Mentionee module
  #
  # This module defines mentionee behavior in mention system
  ###
  module Mentionee
    ###
    # Extends ActiveSupport::Concern
    ###
    extend ActiveSupport::Concern

    ###
    # Included configuration
    ###
    included do
      ###
      # Has many mentioners association configuration
      ###
      has_many :mentioners, class_name: "MentionSystem::Mention", as: :mentionee, dependent: :destroy
    end

    ###
    # Specifies if self can be mentioned by {Mentioner} objects
    #
    # @return [Boolean]
    ###
    def is_mentionee?
      true
    end

    ###
    # Specifies if self is mentioned by a {Mentioner} object
    #
    # @param [Mentioner] mentioner - the {Mentioner} object to test against
    # @return [Boolean]
    ###
    def mentioned_by?(mentioner)
      Mention.mentions?(mentioner, self)
    end

    ###
    # Retrieves a scope of {Mention} objects that mentions self filtered {Mentioner} type
    #
    # @param [Class] klass - the {Class} to filter
    # @return [ActiveRecord::Relation]
    ###
    def mentioners_by(klass)
      Mention.scope_by_mentionee(self).scope_by_mentioner_type(klass)
    end
  end
end

