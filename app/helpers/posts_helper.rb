module PostsHelper
    def is_owner(user_id, owner_id)
         user_id == owner_id
    end    
end
