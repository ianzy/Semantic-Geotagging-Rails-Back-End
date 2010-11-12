# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SemanticGeotagging_session',
  :secret      => '8949eee9f8fca72dc39115c7e217ad95eec02f1a36759ea0d7d60a0a91c83c2d9b8c8db4393117238c39883ea5cf012a9eb9fbade00a567030d71538112f026d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
