require 'dotenv/load'
require 'httparty'
require "json"

# Wrapper class for OPENAI chat API
# documentation: https://platform.openai.com/docs
class OpenAiSDK
  include HTTParty
  base_uri "https://api.openai.com/v1/chat"

  # Set auth on init
  def initialize
    self.class.headers "Authorization" => "Bearer #{ENV["OPENAI_AUTH_TOKEN"]}"
    self.class.headers "Content-Type" => "application/json"
  end

  # Given an assignment prompt, return a string that includes up to 3 follow up questions that might help chatGPT complete the assignment
  def get_follow_up_questions(assignment_prompt)
    ret = self.class.post("/completions",
                          :body => { :model => "gpt-4o-mini",
                                     :messages => [
                                       {
                                         :role => "system",
                                         :content => "You will be given a prompt for a writing assignment and you must ask a maximum of 3 questions to the student to gain enough information to complete the assignment yourself. You may only reply with your questions in the format:\n\n 1: QUESTION 1\n 2. QUESTION 2\n 3. QUESTION 3\n\n You may ask a maximum of three questions, but may ask less as well."
                                       },
                                       {
                                         :role => "user",
                                         :content => "#{assignment_prompt}"
                                       }
                                     ]
                          }.to_json
    )
    ret["choices"][0]["message"]["content"]
  end

  # Given an assignment prompt, follow up questions, and the question answers, ChatGPT will complete the writing assignment to the best of it's ability
  def complete_assignment(assignment_prompt, questions, answers)
    ret = self.class.post("/completions",
                          :body => { :model => "gpt-4o-mini",
                                     :messages => [
                                       {
                                         :role => "system",
                                         :content => "You will be given a prompt for a writing assignment, some questions that were asked to fill in background knowledge and finally the answers to the questions. You must complete the writing assignment to the best of your ability using by using the answers to the questions and knowledge you already know."
                                       },
                                       {
                                         :role => "user",
                                         :content => "Writing assignment prompt:\n#{assignment_prompt}\n\nQuestions:\n#{questions}\n\nAnswers:\n#{answers}\n\n"
                                       }
                                     ]
                          }.to_json
    )
    ret["choices"][0]["message"]["content"]
  end
end
