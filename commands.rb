class ListInterpreter
  # public...
  def initialize()
    @IS_UPCASE = false
    @command = ""
    @validCommands = ["declare", "undeclare", "print", "add", "remove", "clear", 
                        "size", "list", "test_1", "test_2", "test_3", "test_4", "upcase"]
    # hashmap to store all lists...
    @commandMap = Hash.new
    @listMap = Hash.new
  end
  def getCommand
    return @command
  end
  def setCommand(newCommand)
    @command = newCommand
  end
  def execute
    # create a hashmap with the elements in the command string
    populateHashMap()
    # check if the command provided is a valid one
    if ! verifyCommand(@commandMap["command"])
      return false
    end

    # if declare, and the list exists, return an error
    # or is not declare, and list Doesnt exist, return error
    if ((@commandMap["command"] =="declare" && doesListExist()) || ( !(@commandMap["command"] == "declare")) && !doesListExist())
      if (@commandMap["command"] != "upcase" && @commandMap["command"] != "list" )
        puts "invalid list name"
        return false
      end
    end
    
    # call the appropriate function, return its value (we already checked if it is a valid command earlier with verifyCommand...)
    if send("_" << @commandMap["command"])
        clearCommand()
        return true
    end
    return false

  end
  # private functions...
  private
    def populateHashMap()
            # split the command into an array first, at most three elements...
            commandArr = @command.split(' ', 3)
            puts "LENGTH "
            puts commandArr.length
            # store the first element as the command
            @commandMap["command"] = commandArr.first.chomp
            # store the second element as the listName (if applicable)
            @commandMap["listName"] = commandArr.length >= 2 ? commandArr[1].chomp : ""
            # store the third element as the args (if applicable)
            @commandMap["args"] = commandArr.length >= 3 ? commandArr[2].chomp : ""
    end
    def _undeclare
        @listMap.delete(@commandMap["listName"])
        return true
    end
    def _declare
        @listMap[@commandMap["listName"]] = @commandMap["args"].length >= 1 ? @commandMap["args"].split(",") : []
    end
    def doesListExist()
        puts "HELLOOOO"
        if (@commandMap["listName"] == "" || !@listMap.key?(@commandMap["listName"]))
            return false
        end
      return true
    end
    def _upcase
      @IS_UPCASE ? @IS_UPCASE = false : @IS_UPCASE = true
      return true
#      puts "UPCASE VALUE: " + (@IS_UPCASE ? "true" : "false")
    end
    def _list
        @listMap.each {|key, value| printElem("#{key}", value)}
    end
    def _print
        return printElem(@commandMap["listName"], @listMap[@commandMap["listName"]])
    end
    
def _size
       puts "Size of " << @commandMap["listName"] << " is " << @listMap[@commandMap["listName"]].length.to_s
        return true
    end
    def printElem(key, val)
        key << ": "
        print key
        print @IS_UPCASE ? val.map(&:upcase) : val
        return true
    end
    def _add
        @listMap[@commandMap["listName"]] = @listMap[@commandMap["listName"]].concat @commandMap["args"].split(",")
    end

    def verifyCommand(arg)
      puts "verifing: " + arg
      return true unless ! @validCommands.include?(arg)
      return false
    end
    def clearCommand
      @command = ""
    end
    def clearMaps
      @commandMap.clear
      @listMap.clear
    end
end





def main
  listInt = ListInterpreter.new()
  print "> "

  while line = STDIN.readline.chomp
    listInt.setCommand(line)
    if (!listInt.execute())
      puts "there was an error..."
    end
    print "> "
  end

end

# call main
main