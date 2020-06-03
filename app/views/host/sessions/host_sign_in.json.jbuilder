
json.data do
    json.host do 
        json.name @host_sign_in.name
        json.email @host_sign_in.email
    end
    json.auth_token JsonWebToken.encode(host_id: @host_sign_in.id)
end
