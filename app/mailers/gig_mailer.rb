class GigMailer < ApplicationMailer
    def new_user_email
        # @email = params[:email]
    
        mail(to: "gigtracker123@gmail.com", subject: "Welcolme to Gig Tracker")
    end
end
