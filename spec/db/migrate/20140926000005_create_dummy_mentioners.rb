###
# CreateDummyMentioners class
#
# This class defines the create dummy mentioners migration in mention system
###
class CreateDummyMentioners < ActiveRecord::Migration
  ###
  # Changes the database
  ###
  def change
    ###
    # Dummy mentioners table creation
    ###
    create_table :dummy_mentioners do |t|
      ###
      # Timestamps fields definition
      ###
      t.timestamps null: false
    end
  end
end

