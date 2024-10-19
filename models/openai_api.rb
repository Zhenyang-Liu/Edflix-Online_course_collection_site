class OpenAI
  BASE_URL = 'https://api.openai.com/v1/chat/completions'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_course_recommendations(user_input, course_list)

    messages = [
      { role: 'system', content: "Here is the new request，Please recommend courses based on the course list sent to you in conjunction with the user's needs (at least 90% relevance);
      ID and REASON are the identifiers, don't leave them out. All explanations put together for output.
      Fixed answer format: ID + number,REASON:+course_name. For example if you want to recommend course 1 and 2, your answer would be: ID1, ID;REASON:..." }
    ]
  
    course_list.each_with_index do |course|
      messages << { role: 'system', content: "#{course[:id]} - #{course[:name]};" }
    end
    puts "Hello, #{messages}!"
    # Add a detailed reminder message
    messages << { role: 'user', content: user_input }

    request_data = {
    model: 'gpt-4',
    messages: messages,
    temperature: 0.5
    }
  
    uri = URI(BASE_URL)
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{@api_key}"
    req.body = request_data.to_json
  
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http|
      http.request(req)
    }
  
    response_data = JSON.parse(res.body)
    puts "Hello, #{response_data}!"

    # Process the returned JSON data to convert it into an array of course objects
    recommended_courses = []
    reasons = []
    if response_data['choices'] && response_data['choices'][0] && response_data['choices'][0]['message']
      recommendation_text = response_data['choices'][0]['message']['content']
      course_ids = recommendation_text.scan(/ID(\d+)/).flatten
      reasons_text = recommendation_text.scan(/REASON:(.*?)(?:ID|$)/)

      reasons_text.each do |reason|
        reasons << reason[0].strip
      end
  
      course_ids.each do |course_id|
        course = Course[course_id.to_i]
        recommended_courses << course if course
      end
    end
    
    if recommended_courses == []
      accident = response_data['choices'][0]['message']['content'].to_s
      puts "accident, #{accident}!"
      return accident
    else
      [recommended_courses, reasons]
    end
  end
  
end
