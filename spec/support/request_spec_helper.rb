module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  def fetch_todos
    get '/todos', headers: valid_headers
    json
  end
end
