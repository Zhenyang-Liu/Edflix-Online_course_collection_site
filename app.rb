require "require_all"
require "sinatra"
require "sinatra/flash"
require 'sequel'
require 'sqlite3'
require 'sinatra/session'
require "sinatra/reloader"
require 'openssl'
require 'sequel/plugins/validation_helpers'
require 'http'
require 'json'
require 'net/http'
require 'dotenv'

# So we can escape HTML special characters in the view
include ERB::Util

# Sessions
enable :sessions
set :session_secret, "ea72237d3a84b79a317ac59bd8e681bdb573fc20c4446d4698503ce455d2508c"


# App
require_rel "db/db", "controllers", "models"