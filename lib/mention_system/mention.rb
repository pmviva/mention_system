###
# MentionSystem module
#
# This module defines common behavior in mention system
###
module MentionSystem
  ###
  # Mention class
  #
  # This class defines the mention model in mention system
  ###
  class Mention < ActiveRecord::Base
    ###
    # Belongs to mentionee association configuration
    ###
    belongs_to :mentionee, polymorphic: :true

    ###
    # Belongs to mentioner association configuration
    ###
    belongs_to :mentioner, polymorphic: :true

    ###
    # Creates a {Mention} relationship between a {Mentioner} object and a {Mentionee} object
    #
    # @param [Mentioner] mentioner - the {Mentioner} of the relationship
    # @param [Mentionee] mentionee - the {Mentionee} of the relationship
    # @return [Boolean]
    ###
    def self.mention(mentioner, mentionee)
      validate_mentionee(mentionee)
      validate_mentioner(mentioner)

      if mentions?(mentioner, mentionee)
        false
      else
        mention = scope_by_mentioner(mentioner).scope_by_mentionee(mentionee).build
        mention.save
        true
      end
    end

    ###
    # Destroys a {Mention} relationship between a {Mentioner} object and a {Mentionee} object
    #
    # @param [Mentioner] mentioner - the {Mentioner} of the relationship
    # @param [Mentionee] mentionee - the {Mentionee} of the relationship
    # @return [Boolean]
    ###
    def self.unmention(mentioner, mentionee)
      validate_mentionee(mentionee)
      validate_mentioner(mentioner)

      if mentions?(mentioner, mentionee)
        mention = scope_by_mentioner(mentioner).scope_by_mentionee(mentionee).take
        mention.destroy
        true
      else
        false
      end
    end

    ###
    # Toggles a {Mention} relationship between a {Mentioner} object and a {Mentionee} object
    #
    # @param [Mentioner] mentioner - the {Mentioner} of the relationship
    # @param [Mentionee] mentionee - the {Mentionee} of the relationship
    # @return [Boolean]
    ###
    def self.toggle_mention(mentioner, mentionee)
      validate_mentionee(mentionee)
      validate_mentioner(mentioner)

      if mentions?(mentioner, mentionee)
        unmention(mentioner, mentionee)
      else
        mention(mentioner, mentionee)
      end
    end

    ###
    # Specifies if a {Mentioner} object mentions a {Mentionee} object
    #
    # @param [Mentioner] mentioner - the {Mentioner} object to test against
    # @param [Mentionee] mentionee - the {Mentionee} object to test against
    # @return [Boolean]
    ###
    def self.mentions?(mentioner, mentionee)
      validate_mentionee(mentionee)
      validate_mentioner(mentioner)

      scope_by_mentioner(mentioner).scope_by_mentionee(mentionee).exists?
    end

    ###
    # Retrieves a scope of {Mention} objects filtered by a {Mentionee} object
    #
    # @param [Mentionee] mentionee - the {Mentionee} to filter
    # @return [ActiveRecord::Relation]
    ###
    def self.scope_by_mentionee(mentionee)
      where(mentionee: mentionee)
    end

    ###
    # Retrieves a scope of {Mention} objects filtered by a {Mentionee} type
    #
    # @param [Class] klass - the {Class} to filter
    # @return [ActiveRecord::Relation]
    ###
    def self.scope_by_mentionee_type(klass)
      where(mentionee_type: klass.to_s.classify)
    end

    ###
    # Retrieves a scope of {Mention} objects filtered by a {Mentioner} object
    #
    # @param [Mentioner] mentioner - the {Mentioner} to filter
    # @return [ActiveRecord::Relation]
    ###
    def self.scope_by_mentioner(mentioner)
      where(mentioner: mentioner)
    end

    ###
    # Retrieves a scope of {Mention} objects filtered by a {Mentioner} type
    #
    # @param [Class] klass - the {Class} to filter
    # @return [ActiveRecord::Relation]
    ###
    def self.scope_by_mentioner_type(klass)
      where(mentioner_type: klass.to_s.classify)
    end

    private
      ###
      # Validates a mentionee object
      #
      # @raise [ArgumentError] if the mentionee object is invalid
      ###
      def self.validate_mentionee(mentionee)
        raise ArgumentError.new unless mentionee.respond_to?(:is_mentionee?) && mentionee.is_mentionee?
      end

      ###
      # Validates a mentioner object
      #
      # @raise [ArgumentError] if the mentioner object is invalid
      ###
      def self.validate_mentioner(mentioner)
        raise ArgumentError.new unless mentioner.respond_to?(:is_mentioner?) && mentioner.is_mentioner?
      end
  end
end
