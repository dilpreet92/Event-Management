# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.

#FIXME_AB: Read about this and explain to Akhil

Rails.application.config.filter_parameters += [:password]
