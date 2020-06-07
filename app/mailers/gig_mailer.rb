class GigMailer < ApplicationMailer
    def new_user_email
        @email = params[:email]
    
        mail(to: @email, subject: "Welcolme to Gig Tracker")
    end
end
