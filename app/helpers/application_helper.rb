module ApplicationHelper
  def species_emoji(species)
    emojis = {
      "Dog" => "🐶",
      "Cat" => "🐱",
      "Rabbit" => "🐰",
      "Hamster" => "🐹",
      "Guinea pig" => "🐹",
      "Ferret" => "🦦",
      "Bird" => "🐦",
      "Turtle" => "🐢",
      "Fish" => "🐠",
      "Mouse" => "🐭",
      "Rat" => "🐀",
      "Chinchilla" => "🐾",
      "Lizard" => "🦎",
      "Tarantula" => "🕷️",
      "Frog" => "🐸",
      "Goat" => "🐐",
      "Pig" => "🐷",
      "Chicken" => "🐔",
      "Duck" => "🦆",
      "Horse" => "🐴",
      "Donkey" => "🫏",
      "Sheep" => "🐑",
      "Cow" => "🐄",
      "Alpaca" => "🦙",
      "Parrot" => "🦜",
      "Other" => "🐾"
    }
    emojis[species] || "🐾" # Default emoji if species is not found
  end


  def gender_emoji(gender)
    case gender.downcase
    when "male" then "♂️"  # Male symbol
    when "female" then "♀️" # Female symbol
    else "⚧️" # Default for unknown/other
    end
  end

  def country_flag(lat, lon)
    results = Geocoder.search([lat, lon])
    country_code = results.first&.country_code

    return "🏳️" if country_code.blank? # Default flag if not found

    # Convert country code to regional flag emoji
    country_code.upcase.chars.map { |char| (127397 + char.ord).chr(Encoding::UTF_8) }.join
  end

end
