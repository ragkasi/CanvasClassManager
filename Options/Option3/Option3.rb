require_relative '../Option'
require '../Project3/SDKs/CarmenSDK.rb'
require 'nokogiri'
require 'open-uri'




# This code is run when option 3 is selected
private def option_3
  coursesEmpty = 1
  sdk = CarmenSDK.new()
  puts "Option 3: Image Search for Course Textbook"
  puts "Enter the number for the course which you would like to image search a textbook for?"
  courses = sdk.get_courses(false)
  print_courses(courses,coursesEmpty)
  if coursesEmpty == 1
    # Get the text prompt from the user
    prompt = gets.chomp
    puts "Here are the top 3 possible URLs to the top textbooks for your course"
    # find the index of the dash in the course title
    indexOfDash = courses[prompt.to_i-1]["name"].index('-')
    # call scrape function on google image query, from beginning of course name to the dash
    scrape_google_images(courses[prompt.to_i-1]["name"][5...indexOfDash] + 'textbook ohio state')
  end
end

$option3 = Option.new("Textbook Search", -> {option_3})

def get_option_3
  $option3
end

def print_courses(courses, coursesEmpty)
    # Check if the API returned an array
    if !courses.empty?()
      coursesEmpty = 0
      courses.each_with_index do |course, index|
        puts "Course ##{index + 1}: #{course["name"]}"
      end
    # Handle when carmen returns empty array
    else
      coursesEmpty = 1
      puts "Error fetching courses"
    end
end

# Method to search for images based on a text prompt
def scrape_google_images(query)
  encoded_query = URI.encode_www_form_component(query)
  url = "https://www.google.com/search?q=#{encoded_query}&tbm=isch"
  page = Nokogiri::HTML(URI.open(url))
  # Extract image URLs
  images = page.css('img').map { |img| img['src'] }.compact
  count = 0
  # Output only the first 3 images
  images.each_with_index do |img_url, index|
    if count < 4 && count > 0
      puts "Image ##{index}: #{img_url}"
    end
    count = count + 1
  end
end
