class Prompt < ApplicationRecord
  belongs_to :user
  validates :input, presence: true

  # Retrieve the stored output
  def output
    self[:output]
  end

  def valid_response_format?(response)
    begin
      parsed_response = JSON.parse(response)
      parsed_response.is_a?(Array) && parsed_response.all? { |id| id.is_a?(Integer) }
    rescue JSON::ParserError
      false
    end
  end

  # Generate the output using the OpenAI API
  def generate_output
    return self[:output] if self[:output].present?

    puts "_-_-_-_OPENAI API IS BEING CALLED_-_-_-_"
    client = OpenAI::Client.new
    puts "_-_-_-_-INPUT _-_-_-_ #{self.input}"
    # Sanitize the input
    sanitized_input = self.input.strip # Removes leading/trailing whitespace
    sanitized_input = sanitized_input.gsub(/[\r\n\t]/, " ")  # Single line
    puts "_-_-_-_Sanitized Input: _-_-_-_ #{sanitized_input}"

    # Forbidden words check
    forbidden_keywords = [
      "ignore previous", "disregard", "pretend", "bypass", "override",
      "forget this instruction", "respond freely", "act as",

      "modify database", "delete records", "access admin", "SQL injection",
      "drop table", "insert into", "alter table", "execute command", "system access",

      "hack", "exploit", "malware", "phishing", "crack password", "breach security",
      "bypass authentication", "brute force", "DDOS attack", "keylogger",

      "illegal", "black market", "forged documents", "fake ID", "smuggling",
      "money laundering", "stolen credit card", "pirated software", "deepfake",

      "spread false", "fake news", "disinformation", "propaganda",

      "violent act", "terrorism", "bomb instructions", "child exploitation",
      "self-harm", "suicide method", "harm others", "manufacture drugs",

      "remote code execution", "run script", "shell command", "curl request",
      "Python eval", "reverse shell", "Metasploit", "terminal command",

      "disregard safety", "ignore instructions", "change behavior",
      "modify response rules", "circumvent restrictions"
    ]
    if forbidden_keywords.any? { |word| sanitized_input.downcase.include?(word) }
      puts "❌ Forbidden word detected. Returning nil."
      sleep(0.5)
      return nil
    end

    full_prompt = "Respond only with a valid JSON array of ranked ids (e.g., [1, 2, 3]). Do not include any other text, characters, formatting, or explanation. Analyze the user input: #{sanitized_input}. Compare it to the pets: #{self.pets_for_prompt}. Always return 8 pet IDs unless fewer exist. If a preferred species is mentioned, rank all matches first — no exceptions. Order explicitly preferred pets by best suitability. Fill remaining spots with others only after ranking all preferred pets. Never rank a non-preferred species above a preferred one."

    max_retries = 2
    retries = 0

    begin
      chatgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        #model: "gpt-4o",
        messages: [{ role: "user", content: full_prompt }],
      })
      response_content = chatgpt_response["choices"][0]["message"]["content"]


      parsed_pets = JSON.parse(pets_for_prompt) # Converts JSON string to Hash or Array
      parsed_pets.length
      puts "#{parsed_pets.length} pets sent: #{parsed_pets}"
      puts "Prompt sent: #{full_prompt}"
      puts "ChatGPT Response: #{response_content}"


      # Validate the response format
      if valid_response_format?(response_content)
        # Save the response to the database
        self.update(output: response_content)
        return self[:output]
      else
        raise "Invalid response format"
      end
    rescue => e
      retries += 1
      puts "⚠️ Invalid response format. Retrying... (Attempt #{retries}/#{max_retries})"
      sleep(2)
      retry if retries < max_retries

      # If all retries fail, return a placeholder output for rendering the modal
      puts "❌ Failed after #{max_retries} retries: #{e.message}"
      return nil # Indicate that the response was invalid
    end
  end
end
