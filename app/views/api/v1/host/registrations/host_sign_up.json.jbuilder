
json.data do
    json.host do 
        json.name @host_sign_up.name
        json.email @host_sign_up.email
    end
    json.authorization do 
        json.auth_token do 
            json.token JsonWebToken.encode(host_id: @host_sign_up.id)[:jwt]
            json.expires JsonWebToken.encode(host_id: @host_sign_up.id)[:expires]
        end
        json.refresh_token do 
            json.token JsonWebToken.refresh_encode(host_id: @host_sign_up.id)[:refresh_token]
            json.expires JsonWebToken.refresh_encode(host_id: @host_sign_up.id)[:expires]
        end 
    end
end
