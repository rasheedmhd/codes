class CallbackController < ApplicationController
  # Action callbacks have access to response, request objects 
  # and instance variables set by other callbacks, and can create instance variablse
  # for other actions to use
  # this or - inline
  before_action :security_scan, :audit, :compress
  # this - block
  before_action :security_scan
  before_action :audit
  before_action :compress
end
