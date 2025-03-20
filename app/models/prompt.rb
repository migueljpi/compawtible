class Prompt < ApplicationRecord
  belongs_to :user
  has_one :adoption_location, dependent: :destroy
  accepts_nested_attributes_for :adoption_location


  def output
    puts "_-_-_-_OPENAI API IS BEING CALLED_-_-_-_"
    client = OpenAI::Client.new
    full_prompt = "Analyze the user input: #{self.input}. Compare it to the pets: #{self.pets_for_prompt}. Always return 10 pet IDs unless fewer exist. If a preferred species is mentioned, rank all matches first—no exceptions. Order explicitly preferred pets by best suitability. Only after ranking all preferred pets, fill remaining spots with others. Never rank a non-preferred species above a preferred one. Respond only with a valid JSON array of ranked ids (e.g., [1, 2, 3]). Do not include any other text, formatting, or explanation.."
    puts "_-_-_-_PROMPT SENT_-_-_-_ : #{full_prompt}"
    chatgpt_response = client.chat(parameters: {
      #model: "gpt-3.5-turbo",
      model: "gpt-4-turbo",
      messages: [{ role: "user", content: full_prompt}],
    })
    puts "_-_-_-_PETS FOR PROMPT SENT_-_-_-_ : #{self.pets_for_prompt}"
    puts "_-_-_-_ChatGPT Response: _-_-_-_ #{chatgpt_response["choices"][0]["message"]["content"]}"

    return chatgpt_response["choices"][0]["message"]["content"]
  end
end
