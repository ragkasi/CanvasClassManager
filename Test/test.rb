# test cases
require_relative 'TestManager.rb'
require_relative '../SDKs/CarmenSDK.rb'
require_relative '../SDKs/LoveCalculatorSDK'
require_relative '../Options/Option3/Option3.rb'
require 'nokogiri'
require 'open-uri'

$test_manager = TestManager.new

# get_courses tests
def test_get_courses_1
  $test_manager.v_print "\nGet Courses Test 1 (With Grade):"
  api = CarmenSDK.new
  response = api.get_courses(true)

  if response.code == 200
    courses_with_grades = JSON.parse(response.body)

    for course in courses_with_grades
      $test_manager.v_print(course['name'])

      # check that grades are not included 
      if !course["enrollments"][0]["computed_final_score"]
        $test_manager.v_print "Grades were not include when they should be"
        return true
      end

      if course["enrollments"]
        $test_manager.v_print "Final score: #{course["enrollments"][0]["computed_final_score"]}"
      else
        $test_manager.v_print "No enrollments found."
      end
    end

    return true

  else
    return false
  end
end

$test_manager.add_test("Get courses with grades", -> { test_get_courses_1 })

def test_get_courses_2
  $test_manager.v_print "\nGet Courses Test 2 (Without Grade):"
  api = CarmenSDK.new
  response = api.get_courses(false)

  if response.code == 200
    courses_with_grades = JSON.parse(response.body)

    for course in courses_with_grades
      $test_manager.v_print course['name']

      # check that grades are not included 
      if course["enrollments"][0]["computed_final_score"]
        $test_manager.v_print "Grades were include when they should not be"
        return false
      end
    end

    return true

  else
    return false
  end
end

$test_manager.add_test("Get courses without grades", -> { test_get_courses_2 })

# get_assignments tests
def test_get_assignments_1
  $test_manager.v_print "\nGet Assignments Test 1:"
  api = CarmenSDK.new
  # Change this to course IDs of class you have taken. 
  response = api.get_assignments(130430)

  if response.code == 200
    assignments = JSON.parse(response.body)
    for assignment in assignments
      $test_manager.v_print assignment['name']
    end
    return true

  else
    $test_manager.v_print "Did you remember to change the course ID to a class you have taken?"
    return false
  end
end

$test_manager.add_test("Get assignments test 1", -> { test_get_assignments_1 })

# put in a different course ID to compare with test_get_assignments_1
def test_get_assignments_2
  $test_manager.v_print "\nGet Assignments Test 2:"
  api = CarmenSDK.new

  # course id of Web Apps
  response = api.get_assignments(171680)

  if response.code == 200
    assignments = JSON.parse(response.body)
    for assignment in assignments
      $test_manager.v_print assignment['name']
    end
    return true

  else
    $test_manager.v_print "Did you remember to change the course ID to a class you have taken?"
    return false
  end
end

$test_manager.add_test("Get assignments test 2", -> { test_get_assignments_2 })

# Tests for submit_text_assignment go here

# put in a different course ID to compare with test_get_assignments_1
def get_user_profile_test
  $test_manager.v_print "\nGet User Profile Info Test 1:"
  api = CarmenSDK.new
  response = api.get_user_profile

  if response.code == 200
    user_info = JSON.parse(response.body)

    $test_manager.v_print "Name: #{user_info['name']}"
    $test_manager.v_print "Avatar Url: #{user_info['avatar_url']}"
    $test_manager.v_print "Email: #{user_info['primary_email']}"

    return true

  else
    return false
  end
end

$test_manager.add_test("Get user profile info test", -> { get_user_profile_test })

# get_course_gpa tests
def test_get_course_gpa_1
  $test_manager.v_print "\nGet Course GPA Test 1:"

  api = CarmenSDK.new

  # This is the course ID of Web Apps. Test should pass for everyone as long as webapps is favorited on Carmen
  course_id = 171680
  response1 = api.get_course_gpa(course_id)
  response2 = api.get_courses_favorites(true)

  if response2.code == 200
    courses_with_grades = JSON.parse(response2.body)
    for course in courses_with_grades
      if course['id'] == course_id
        $test_manager.v_print "Course: #{course['name']}"
        $test_manager.v_print "GPA: #{response1}"

        letter_grade = course["enrollments"][0]["computed_current_grade"]
        if letter_grade == "A"
          if response1 == 4.0
            return true
          else
            return false
          end
        elsif letter_grade == "A-"
          if response1 == 3.7
            return true
          else
            return false
          end
        elsif letter_grade == "B+"
          if response1 == 3.3
            return true
          else
            return false
          end
        elsif letter_grade == "B"
          if response1 == 3.0
            return true
          else
            return false
          end
        elsif letter_grade == "B-"
          if response1 == 2.7
            return true
          else
            return false
          end
        elsif letter_grade == "C+"
          if response1 == 2.7
            return true
          else
            return false
          end
        elsif letter_grade == "C"
          if response1 == 2.0
            return true
          else
            return false
          end
        elsif letter_grade == "C-"
          if response1 == 1.7
            return true
          else
            return false
          end
        elsif letter_grade == "D+"
          if response1 == 1.3
            return true
          else
            return false
          end
        elsif letter_grade == "D"
          if response1 == 1.0
            return true
          else
            return false
          end
        end
      end
    end
  end
  $test_manager.v_print "Did you remember to change the course_id?"
  return false
end

$test_manager.add_test("Get course gpa test 1", -> { test_get_course_gpa_1 })

# love compatability tests
def test_get_love_compatability_score_1
  api = LoveCalculatorSDK.new
  res = api.get_love_percentage("Baha", "Erik")
  if res["result"] != 76 || res["personB"] != "Erik" || res["personA"] != "Baha"
    return false
  end
  true
end
$test_manager.add_test("Get Love Compatability Score", -> { test_get_love_compatability_score_1 })

# get_assignments tests
def test_get_love_compatability_score_2
  api = LoveCalculatorSDK.new
  res = api.get_love_percentage_bulk("Erik", ["Baha", "Blast"])
  baha_res = res.select {|ele| ele["personA"] == "Baha"}.first
  blast_res = res.select {|ele| ele["personA"] == "Blast"}.first
  if baha_res["result"] != 76 || baha_res["personA"] != "Baha" || baha_res["personB"] != "Erik"
    return false
  end
  if blast_res["result"] != 95 || blast_res["personA"] != "Blast" || blast_res["personB"] != "Erik"
    return false
  end
  true
end
$test_manager.add_test("Get Love Compatability Score 2", -> { test_get_love_compatability_score_2 })

# Scrape images test
def test_get_textbook_images_1
  encoded_query = URI.encode_www_form_component("roses")
  url = "https://www.google.com/search?q=#{encoded_query}&tbm=isch"
  page = Nokogiri::HTML(URI.open(url))
  # Extract image URLs
  images = page.css('img').map { |img| img['src'] }.compact
  if images.empty?()
    return false
  end
  true
end
$test_manager.add_test("Textbook Search", -> { test_get_textbook_images_1 })

# Print courses test
def test_get_textbook_images_2
  coursesEmpty = 1
  sdk = CarmenSDK.new()
  courses = sdk.get_courses(false)
  # Check if the API returned an array
  if courses.empty?()
    return false
  end
  true
end
$test_manager.add_test("Textbook Search 2", -> { test_get_textbook_images_2 })

# Run tests. Switch verbose param to true for v_print log messages.
$test_manager.run_tests false