# class ApplicationController < ActionController::Base
#   before_action :set_guest_user

#   private def set_guest_user
#     # Check if there is already a user stored in the session
#     unless session[:user_id]
#       # Create a new user record (you can modify attributes as needed)
#       user = User.new
#       # Store the user ID in the session
#       session[:user_id] = user.id
#       session[:user] = user
#     end
#   end
# end

# class LoginsController < ApplicationController
#   skip_before_action :require_login, only: [:new, :create]
# end

class ApplicationController < ActionController::Base
  # Checks on all routes, this means, we can't even log in
  # see skip_before_action 
  # before_action :require_login
  before_action :set_guest_candidate

  private 
    def set_guest_candidate
      if session[:candidate].present?
        @candidate = session[:candidate]
      else
        candidate = Candidate.new(name: "guest", email: "guest@guestmail.com", created_at: Time.now)
        session[:candidate] = candidate
      end
    end

    # def require_login
    #   unless logged_in?
    #     flash[:error] = "You must be logged in to access this route"
    #     redirect_to new_users_path
    #   end
    # end

    # Another way to write Action Callbacks
    # before_action do |controller|
    #   unless controller.send(:logged_in?)
    #     flash[:error] = "You must be logged in to access this section"
    #     redirect_to new_login_url
    #   end
    # end

end


