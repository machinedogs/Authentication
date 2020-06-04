
json.data do
    json.authorization do 
        json.auth_token do 
            json.token JsonWebToken.encode(host_id:  @refresh_tokens[:host_id])[:jwt]
            json.expires JsonWebToken.encode(host_id:  @refresh_tokens[:host_id])[:expires]
        end
        json.refresh_token do 
            json.token JsonWebToken.refresh_encode(host_id:  @refresh_tokens[:host_id])[:refresh_token]
            json.expires JsonWebToken.refresh_encode(host_id:  @refresh_tokens[:host_id])[:expires]
        end 
    end
end


