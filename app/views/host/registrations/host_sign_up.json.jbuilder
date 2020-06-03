json.data do
    json.host do 
        json.name @host_sign_up.name
        json.email @host_sign_up.email
    end
    json.auth_token JsonWebToken.encode(host_id: @host_sign_up.id)
end
