class Text < ApplicationRecord

  has_one :adoption_location, dependent: :destroy
  accepts_nested_attributes_for :adoption_location


  def output
    puts "_-_-_-_OPENAI API IS BEING CALLED_-_-_-_"
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      #model: "gpt-4-turbo",
      messages: [{ role: "user", content: "Analyze the following text: #{self.input}. Find the pet that best matches it here: #{self.database}. Do not show your reasoning or any other text, only the ID of the best match as an integer." }]
    })
    puts "_-_-_-_DATABSE SENT_-_-_-_ : #{self.database}"
    puts "_-_-_-_ChatGPT Response: _-_-_-_ #{chatgpt_response["choices"][0]["message"]["content"]}"

    return chatgpt_response["choices"][0]["message"]["content"]
  end
end
