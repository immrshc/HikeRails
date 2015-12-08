json.extract! @post, :id unless @post.nil?
json.username @post.user.username unless @post.nil?
json.result @result
