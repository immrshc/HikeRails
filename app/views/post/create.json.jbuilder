json.extract! @post, :id unless @post.nil?
json.username @post.user unless @post.nil?
json.result @result
