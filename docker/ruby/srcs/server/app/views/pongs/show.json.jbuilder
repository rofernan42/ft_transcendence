json.extract! @pong, :id, :user_left_id, :user_right_id, :user_left_score, :user_right_score, :done, :started, :mode, :playing, :winner, :looser, :tie, :room_id
json.url pong_url(@pong, format: :json)
