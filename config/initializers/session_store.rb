# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SalesScrapers_session',
  :secret      => '8b567d35292ebda1f2dbf42097d6a3a08d03130f028527efc72c4658ae28876acf7517da9e65da60bc74c5b80104569260875ffd3751265742e8397bce19cc00'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
