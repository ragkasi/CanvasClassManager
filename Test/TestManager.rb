# Used for testing functions. Migrated over from our team's Project 2
class TestManager
    def initialize
      @tests = []
      @verbose = false
    end

    def v_print(string)
      if @verbose
        puts string
      end
    end
  
    def add_test(name, testFunc)
      @tests.push({name: name, testFunc: testFunc})
    end
  
    def run_tests(verbose=false)
      puts "Running #{@tests.length} tests..."
      @verbose = verbose
      successes = 0
      # run each test
      for test in @tests
        result = test[:testFunc].call
        # track successes, print failures
        if result
          successes += 1
        else
          puts "\e[31mTest #{test[:name]} Failed!\e[0m"
        end
      end
      # Ending status message
      puts "\nRan #{@tests.length} tests.\n\e[32m#{successes} Successes\e[0m, \e[31m#{@tests.length - successes} Failures.\e[0m"
  
      # return true if all tests passed
      successes == @tests.length
    end
  end