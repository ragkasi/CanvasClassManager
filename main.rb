require_relative 'Options/Option1/Option1'
require_relative 'Options/Option2/Option2'
require_relative 'Options/Option3/Option3'
require_relative 'Options/Option4/Option4'
require_relative 'Options/Selector'

# loop tracking
loop = true

# options set up
options = [get_option_1, get_option_2, get_option_3, get_option_4, Option.new("Exit", ->{loop = false})]

while loop
  # Prompt user for an option
  puts "\nSelect an option by entering it's corresponding number:\n"
  selector = Selector.new(options, -> (option) {option.to_s})
  selected_option = selector.select_option

  # Call the option's function
  selected_option.call
end