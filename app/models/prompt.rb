class Prompt < ApplicationRecord
  belongs_to :user
  validates :input, presence: true
  # has_one :adoption_location, dependent: :destroy
  # accepts_nested_attributes_for :adoption_location


  def output
    return self[:output] if self[:output].present?

    puts "_-_-_-_OPENAI API IS BEING CALLED_-_-_-_"
    client = OpenAI::Client.new
    full_prompt = "Respond only with a valid JSON array of ranked ids (e.g., [1, 2, 3]). Do not include any other text, characters, formatting, or explanation. Analyze the user input: #{self.input}. Compare it to the pets: #{self.pets_for_prompt}. Always return 10 pet IDs unless fewer exist. If a preferred species is mentioned, rank all matches first — no exceptions. Order explicitly preferred pets by best suitability. Fill remaining spots with others only after ranking all preferred pets, Never rank a non-preferred species above a preferred one."
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      #model: "gpt-4-turbo",
      messages: [{ role: "user", content: full_prompt }],
    })
    puts "_-_-_-_USER INPUT_-_-_-_ : #{self.input}"
    puts "_-_-_-_PETS FOR PROMPT SENT_-_-_-_ : #{self.pets_for_prompt}"
    puts "_-_-_-_PROMPT SENT_-_-_-_ : #{full_prompt}"
    puts "_-_-_-_ChatGPT Response: _-_-_-_ #{chatgpt_response["choices"][0]["message"]["content"]}"

    # Save the response to the database
    self.update(output: chatgpt_response["choices"][0]["message"]["content"])
    return self[:output]
  end
end
