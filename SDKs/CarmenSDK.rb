require 'dotenv/load'
require 'httparty'
require "json"

# Wrapper class for Carmen Canvas API
# Documentation: https://canvas.instructure.com/doc/api/index.html
class CarmenSDK
  include HTTParty
  base_uri 'https://osu.instructure.com/api/v1'

  # set token on init
  def initialize
    self.class.headers "Authorization" => "Bearer #{ENV["CANVAS_AUTH_TOKEN"]}"
    self.class.headers "Content-Type" => "application/json"
  end

  # fetches all of the user's active courses. Includes grade data if `include_grades` param is true
  def get_courses(include_grades = false)
    options = { :query => {} }
    if include_grades
      options[:query] = { "include[]" => "total_scores" }
    end
    self.class.get("/courses", options)
  end


  # fetches all of the user's active courses. Includes grade data if `include_grades` param is true
  def get_courses_favorites(include_grades = false)
    options = { :query => { } }
    if include_grades
      options[:query] = { "include[]" => "total_scores" }
    end
    self.class.get("/users/self/favorites/courses", options)
  end

  # fetches all of the user's assignments in a course
  def get_assignments(course_id)
    self.class.get("/courses/#{course_id}/assignments")
  end

  # fetches all of a courses students
  def get_students(course_id)
    options = { :query => { "per_page"=> 100 } }
    self.class.get("/courses/#{course_id}/users", options)
  end

  # submits `content` as a text submission for the given assignment
  def submit_text_assignment(course_id, assignment_id, content)
    self.class.post("/courses/#{course_id}/assignments/#{assignment_id}/submissions",
                    { :query => {
                      :submission => {
                        :submission_type => "online_text_entry",
                        :body => content
                      }
                    } }
    )
  end

  # fetches user profile information
  def get_user_profile
    options = { :query => {} }
    self.class.get("/users/self/profile", options)
  end

  # calculate course GPA based on letter grade
  def get_course_gpa(course_id)
    response = get_courses_favorites(true)
    if response.code == 200
      courses_with_grades = JSON.parse(response.body)

      for course in courses_with_grades
        if course['id'] == course_id
          letter_grade = course["enrollments"][0]["computed_current_grade"]
          if letter_grade == "A"
            return 4.0
          elsif letter_grade == "A-"
            return 3.7
          elsif letter_grade == "B+"
            return 3.3
          elsif letter_grade == "B"
            return 3.0
          elsif letter_grade == "B-"
            return 2.7
          elsif letter_grade == "C+"
            return 2.3
          elsif letter_grade == "C"
            return 2.0
          elsif letter_grade == "C-"
            return 1.7
          elsif letter_grade == "D+"
            return 1.3
          elsif letter_grade == "D"
            return 1.0
          end
        end
      end

      return nil

    end
  end

end
