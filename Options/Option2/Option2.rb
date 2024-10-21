require_relative '../Option'

# This code is run when option 2 is selected
private def option_2
  puts "Hello, Option 2!"
end

$option2 = Option.new("This is the name of Option 2", -> {option_2})

def get_option_2
  $option2
end

