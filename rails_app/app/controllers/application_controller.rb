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

class ApplicationController < ActionController::Base
  before_action :set_guest_candidate

  private def set_guest_candidate
    if session[:candidate].present?
      @candidate = session[:candidate]
    else
      candidate = Candidate.new(name: "guest", email: "guest@guestmail.com", created_at: Time.now)
      session[:candidate] = candidate
    end
  end
end


