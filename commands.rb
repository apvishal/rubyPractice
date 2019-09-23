#################################
# Programmer: Vishal Patel
# Date: 09/22/2019
#################################

# NOTE: 
# ruby --version
# ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-linux]

# ListInterpreter class
# 	This class has the following members:
# 		- IS_UPCASE 
# 			- will be used to determine if the outputs should be in uppercase or not
# 		- command
# 			- the entire command entered by the user will be stored in this variable (mostly used for debugging)
# 		- validCommands
# 			- an array of all of the valid commands specified in the assignment description
# 		- commandMap
# 			- used to parse the string 'command' into a map with the following keys:
# 				- command
# 				- listName
# 				- args
# 		- listMap
# 			- used to store all of the declared lists with a key, value pair
#
# 	This class has the following public functions:
# 		- getCommand
# 			- returns the command as a string (used for debugging)
# 		- setCommand
# 			- stores the command entered by the user
# 		- execute
# 			- populates the commandMap with the appropriate keys
# 			- verifies if the command is contained within the member validCommands
# 			- checks if the list name is valid, whether it exists or not when applicable
# 			- calls the appropriate function based on the command
# 			- returns true of the command was executed sucessfully
# 	This class has the following private functions
# 		- populateHashMap
# 			- parses the command string and builds a map with the following keys: command, listName, args
#		- isValidListName
#			- checks if a listName is valid depending on the command entered by the user
#		- _undeclare
#			- undeclares a specified list name
#		- _declare
#			- declares a specified list name
#		- doesListExist
#			- checks if a list exists
#		- _upcase
#			- toggles IS_UPCASE value
#		- _list
#			- prints all lists contained in the map
#		- _print
#			- prints a single list specified by the user
#		- _size
#			- prints the size of a list specified by the user
#		- _clear
#			- clears the contents of a list specified by the user
#		- printPair(key, val)
#			- prints a key, then calls printValue 
#		- printValue(val)
#			- prints a value provided as arguement, prints in upper case if IS_UPCASE is true
#		- _add
#			- adds values provided to a specified list
#		- _remove
#			- removes a value provided from a specified list
#		- verifyCommand
#			- verifies if a command exists in the array validCommands
#		- _test_1
#			- prints all elements in a list that ends with the character 'e'
#		- _test_2
#			- prints test_2 will print elements of a list whose lengths are greater than 3 but less than 6, or is greater than 7
#		- _test_3
#			- displays up to five elements of an array whose lengths are greater than 8 characters
#		- _test_4
#			- prints elements of a list that contain a substring defined in commandMap[args]

class ListInterpreter
  def initialize()
    @IS_UPCASE = false
    @command = ""
    # commands that are valid to this program
    @validCommands = ["declare", "undeclare", "print", "add", "remove", "clear", 
                        "size", "list", "test_1", "test_2", "test_3", "test_4", "upcase"]
    # hashmaps to store commands and lists...
    @commandMap = Hash.new
    @listMap = Hash.new
  end

  # public functions...
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
      puts "Command not found " + @commandMap["command"]
      return false
    end

    # if declare, and the list exists, return an error
    # or is not declare, and list Doesnt exist, return error
    # check if the list is a valid name under the appropriate conditions... 
    if (! isValidListName() )
	    return false
    end 
    # call the appropriate function, return its value (we already checked if it is a valid command earlier with verifyCommand...)
    if send("_" << @commandMap["command"])
      return true
    end
    return false
  end

  # private functions...
  private
    # populateHashMap will take the command string and parse it, putting elements into a commandMap with a key,value pair
    def populateHashMap()
      # split the command into an array first, at most three elements...
      commandArr = @command.split(' ', 3)
      # store the first element as the command
      @commandMap["command"] = commandArr.first.chomp
      # store the second element as the listName (if applicable)
      @commandMap["listName"] = commandArr.length >= 2 ? commandArr[1].chomp : ""
      # store the third element as the args (if applicable)
      @commandMap["args"] = commandArr.length >= 3 ? commandArr[2].chomp : ""
    end

    # isValidListName checks if the list exists or not depending on the stored command
    def isValidListName()
      if (@commandMap["command"] =="declare" && doesListExist())
        # the list already exists... cannot declare it again
        puts "Error: List \"" + @commandMap["listName"] + "\" already exists"
        return false
      end
      if (((!(@commandMap["command"] == "declare")) && !doesListExist()) && @commandMap["command"] != "upcase" && @commandMap["command"] != "list")
        # not declare, upcase, list, nor clear.  the list name does not exist...
        puts "Error: List \"" + @commandMap["listName"] + "\" doesn't exist"
        return false
      end
      # if the listName is valid
      return true
    end

    # undecare will undeclare the listname that is specified by the user
    def _undeclare
      result = @listMap.delete(@commandMap["listName"])
      if result != nil
        puts "Removed " + @commandMap["listName"]
      end
      return true
    end

    # declare will create a list in listMap with the name specified by the user
    def _declare
      @listMap[@commandMap["listName"]] = @commandMap["args"].length >= 1 ? @commandMap["args"].split(",").map(&:strip) : []
      puts "Created " + @commandMap["listName"] + ": " + @listMap[@commandMap["listName"]].inspect
      return true
    end

    # doesListExist checks if a list exists in listMap
    def doesListExist()
      if (@commandMap["listName"] == "" || !@listMap.key?(@commandMap["listName"]))
        return false
      end
      return true
    end

    # upcase toggles IS_UPCASE between true and false
    def _upcase
      @IS_UPCASE ? @IS_UPCASE = false : @IS_UPCASE = true
      return true
    end

    # list will print each list in listMap
    def _list
      @listMap.each {|key, value| printPair("#{key}", value)}
    end

    # print will print a specfied list
    def _print
      return printPair(@commandMap["listName"], @listMap[@commandMap["listName"]])
    end
    # size will print the size of a specified list
 
    def _size
      puts "Size of " << @commandMap["listName"] << " is " << @listMap[@commandMap["listName"]].length.to_s
      return true
    end
    # clear will clear the contents of a specific list
 
    def _clear
      @listMap[@commandMap["listName"]] = []
      puts "Cleared " + @commandMap["listName"]
      return true
    end

    # printPair will print a list in a format depending on IS_UPCASE
    def printPair(key, val)
      key << ": "
      print key
      printValue(val)
      return true
    end

    def printValue(val)
      print @IS_UPCASE ? val.map(&:upcase) : val
      puts ""	
    end

    # add will add elements to a list
    def _add
      @listMap[@commandMap["listName"]] = @listMap[@commandMap["listName"]].concat @commandMap["args"].split(",").map(&:strip)
      outputString = "Added "
      @commandMap["args"].split(",").each {|elem| outputString = outputString + "\"" + elem + "\" " }
      outputString += "to the list"
      puts outputString
      return true
    end

    # remove will remove elements from a list
    def _remove
	    index = @listMap[@commandMap["listName"]].index(@commandMap["args"])
      if (index != nil)
        @listMap[@commandMap["listName"]].delete_at(index)
        puts "Removed index " + index.to_s + " of " + @commandMap["listName"]
      end
	    return true
    end

    # verifyCommand will check if a command is recognized 
    def verifyCommand(arg)
      return true unless ! @validCommands.include?(arg)
      return false
    end

    # test_1 will print elements of a list that does not end with the character 'e'
    def _test_1
      outputString = "test_1 on " + @commandMap["listName"] + ": "
      print outputString
      printValue(@listMap[@commandMap["listName"]].select{|elem| elem[-1] != "e"})
      return true
    end

    # test_2 will print elements of a list whose lengths are greater than 3 but less than 6, or is greater than 7
    def _test_2
	    outputString = "test_2 on " + @commandMap["listName"] + ": "
      print outputString
	    printValue(@listMap[@commandMap["listName"]].select{|elem| ((elem.length > 3 && elem.length < 6) || elem.length > 7)})
      return true
    end

    # displays up to five elements who lengths are greater than 8 characters
    def _test_3
      outputString = "test_3 on " + @commandMap["listName"] + ": "
      print outputString
	    printValue(@listMap[@commandMap["listName"]].select{|elem| (elem.length > 8)}[0...5])
	    return true
    end

    # test_4 will print elements of a list that contain a substring defined in @commandMap[args]
    def _test_4
	    outputString = "test_4 on " + @commandMap["listName"] + ": "
      print outputString
      printValue(@listMap[@commandMap["listName"]].select{ |elem| elem.include? @commandMap["args"]})
      return true
    end
end # end ListInterpreter

# main will create an instance of ListInterpreter, and loop infinitley to execute commands
# provided in the user's input.  The loop will exit once the user enters a blank input.  
# After detecting a blank input, the program will exit.  
#
def main
  # create instance of ListInterpreter
  listInt = ListInterpreter.new()
  # print the prompt
  print "> "

  # infinite while loop
  while line = STDIN.readline.chomp
    # break out of the loop if an empty string is detected
    break unless line != ""
    # set the command to the string contained in 'line'
    listInt.setCommand(line)
    # attempt to execute the command
    if (!listInt.execute())
      # inform user that there was an error (another print would be printed above here if there really was an error as well)
      puts "there was an error..."
    end
    # prompt the user for the next command:w
    print "> "
  end # end while

  puts "Bye"
end # end main

# call main
main
