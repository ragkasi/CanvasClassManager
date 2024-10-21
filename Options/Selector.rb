# This class helps create selectable menus.
# Example usage below.
class Selector
  # Pass options, and an option -> label mapping function
  def initialize(options, label_map_function)
    @options = options
    @label_map_function = label_map_function
  end

  # Prints out all of the options in an ordered list and asks the user to select one.
  # The mapping function supplied at initialization is used to create the labels
  # Once the user selects an option, that option is returned.
  def select_option
    # Print out all of the options
    @options.each_with_index do |option, index|
      puts "#{index+1}. #{@label_map_function.call(option)}"
    end

    # Loop until we see a valid input
    selected_option = nil
    while true
      # sanitation
      user_input = gets.chomp.to_i - 1
      selected_option = @options[user_input]

      # check if input was valid
      if selected_option == nil || user_input < 0
        # loop if input was bad.
        puts "Invalid input!"
      else
        return selected_option
      end
    end
  end
end