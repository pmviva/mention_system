require 'active_record'

###
# Active record database configuration
###
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

###
# Active record migrator configuration
###
ActiveRecord::Migrator.up 'spec/db/migrate'

