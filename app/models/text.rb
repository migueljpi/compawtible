class Text < ApplicationRecord

  def output
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      #model: "gpt-4-turbo",
      messages: [{ role: "user", content: "Return only the first characters of each word as a acronym: #{self.input}" }]
    })
    return chatgpt_response["choices"][0]["message"]["content"]
  end
end
