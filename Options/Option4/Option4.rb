require_relative '../Option'
require_relative '../../SDKs/CarmenSDK'
require_relative '../../SDKs/LoveCalculatorSDK'
require_relative '../Selector'

# This code is run when option 4 is selected
private def option_4
  sdk = CarmenSDK.new
  love_sdk = LoveCalculatorSDK.new

  # Grab courses
  courses = sdk.get_courses_favorites

  if courses.length == 0
    puts "Looks like you have no courses. Too bad!"
  end

  # User selects a course
  puts "\nPlease select one of your active courses from the list below: "
  selector = Selector.new(courses, -> (course) { course["name"] })
  selected_option = selector.select_option

  # Get the members of the user's class. Dont include user themselves.
  user_name = sdk.get_user_profile["name"]
  students = sdk.get_students(selected_option["id"]).map { |student| student["name"] }.select { |name| name != user_name }

  if students.length == 0
    puts "Looks like you have no classmates to study with. Too bad!"
  end

  # Get the top match!
  love_match = love_sdk.get_love_percentage_bulk(user_name, students).sort { |a, b| b["result"] <=> a["result"] }.first

  if love_match == nil
    puts "Love is not in the air. Try again some other time."
  end

  # Set up the two lovebirds
  match = love_match["personA"]
  score = love_match["result"]
  puts "Your ideal study date for #{selected_option["name"]} is #{match}. You and #{match} have a love compatability of #{score}%! Congratulations!"
end

$option4 = Option.new("Find my ideal study date ❤️", -> { option_4 })

def get_option_4
  $option4
end

