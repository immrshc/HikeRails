json.extract! @user, :token, :username unless @user.nil?
json.result @result
