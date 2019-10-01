require "httparty"
require "JSON"
require "RMagick"
require "catpix"
require "open-uri"


quiz = {
    name: "",
    types: [],
    answer: "",
    image: ""
}

puts "Welcome to the Pokemon Trivia Game"
sleep(1)
puts "Where your knowledge of Pokemon types will be tested"

pokemon_id = rand(1..150)
name_endpoint = "https://pokeapi.co/api/v2/pokemon/#{pokemon_id}/"

response = HTTParty.get(name_endpoint,
    {
        body: {
        },
        headers: {
        }
    }
)

if (response.code != 200)
    puts "Something went wrong"
    exit
end

data = JSON.parse(response.body)
quiz[:name] = data["species"]["name"]
quiz[:types].push data["types"][0]["type"]["name"]
quiz[:answer] = data["types"][0]["type"]["name"]
quiz[:image] = data["sprites"]["front_default"]

open("image.png", "wb") do |file|
    file << open(quiz[:image]).read
end

while (quiz[:types].length < 3)

    type_id = rand(1..18)
    type_endpoint = "https://pokeapi.co/api/v2/pokemon/#{type_id}/"

    response = HTTParty.get(type_endpoint,
        {
            body: {
            },
            headers: {
            }
        }
    )

    if (response.code != 200)
        puts "Something went wrong"
        exit
    end

    data = JSON.parse(response.body)
    curr_type = data["types"][0]["type"]["name"]


    if not quiz[:types].include?(curr_type)
        quiz[:types].push curr_type
    end

end
quiz[:types].shuffle!
system("catpix image.png")
puts "What type of pokemon is #{quiz[:name].capitalize}:"
puts "1. #{quiz[:types][0]}"
puts "2. #{quiz[:types][1]}"
puts "3. #{quiz[:types][2]}"

while true do
    user_guess = gets.chomp.to_i - 1

    if (0..2).include?(user_guess)
        break
    else 
        puts "Please enter a valid input"
    end
end

if quiz[:answer] == quiz[:types][user_guess]
    puts "Correct"
else
    puts "Nope, #{quiz[:name]} is a #{quiz[:answer]} pokemon"
end

