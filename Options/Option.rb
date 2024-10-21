# Menu option class. Just holds a label and a function to run on selection
class Option
  # Name is a string, func is a function with no parameters.
  def initialize(name, func)
    @name = name
    @func = func
  end

  def call
    @func.call
  end

  def to_s
    @name
  end
end