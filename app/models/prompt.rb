class Prompt < ApplicationRecord
  belongs_to :user
  has_one :adoption_location, dependent: :destroy
  accepts_nested_attributes_for :adoption_location


  def output
    puts "_-_-_-_OPENAI API IS BEING CALLED_-_-_-_"
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      #model: "gpt-4-turbo",
      messages: [{ role: "user", content: "Analyze the following text: #{self.input}. Find the pet that best matches it here: #{self.pets_for_prompt}. Do not show your reasoning or any other text, only the ID of the best match as an integer." }]
    })
    puts "_-_-_-_PETS FOR PROMPT SENT_-_-_-_ : #{self.pets_for_prompt}"
    puts "_-_-_-_ChatGPT Response: _-_-_-_ #{chatgpt_response["choices"][0]["message"]["content"]}"

    return chatgpt_response["choices"][0]["message"]["content"]
  end
end
