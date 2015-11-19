###
# CreateDummyMentionees class
#
# This class defines the create dummy mentionees migration in mention system
###
class CreateDummyMentionees < ActiveRecord::Migration
  ###
  # Changes the database
  ###
  def change
    ###
    # Dummy mentionees table creation
    ###
    create_table :dummy_mentionees do |t|
      ###
      # Timestamps fields definition
      ###
      t.timestamps null: false
    end
  end
end

