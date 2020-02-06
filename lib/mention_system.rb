require 'mention_system/mention'
require 'mention_system/mention_processor'
require 'mention_system/mentionee'
require 'mention_system/mentioner'

###
# MentionSystem module
#
# This module defines common behavior in mention system
###
module MentionSystem
  ###
  # Specifies if self can be mentioned by {Mentioner} objects
  #
  # @return [Boolean]
  ###
  def is_mentionee?
    false
  end

  ###
  # Specifies if self can mention {Mentionee} objects
  #
  # @return [Boolean]
  ###
  def is_mentioner?
    false
  end

  ###
  # Instructs self to act as mentionee
  ###
  def act_as_mentionee
    include Mentionee
  end

  ###
  # Instructs self to act as mentioner
  ###
  def act_as_mentioner
    include Mentioner
  end
end

ActiveRecord::Base.extend MentionSystem
