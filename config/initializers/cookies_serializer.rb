# Be sure to restart your server when you modify this file.

Rails.logger.info "Starting cookies_serializer"

# Specify a serializer for the signed and encrypted cookie jars.
# Valid options are :json, :marshal, and :hybrid.
Rails.application.config.action_dispatch.cookies_serializer = :json


Rails.logger.info "Finished cookies_serializer"