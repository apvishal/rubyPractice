
class ListInterpreter
  # public...
  def initialize()
    @IS_UPCASE = false
    @command = ""
    @validCommands = ["declare", "undeclare", "print", "add", "remove", "clear", 
                        "size", "list", "test_1", "test_2", "test_3", "test_4", "upcase"]
    # hashmap to store all lists...
    @listHash = Hash.new
  end
  def getCommand
    return @command
  end
  def setCommand(newCommand)
    @command = newCommand
  end
  def execute
    # extract the command from the string ( if this is a valid command string, then the command will be the first word in the string)
    currentCommand = @command.split(' ').first
	# check if the currentCommand is a valid one
    if ! verifyCommand(currentCommand)
      return false
    end
    # check if the command is 'upcase' or 'list'
    if currentCommand.eql?("upcase") || currentCommand.eql?("list") || currentCommand.eql?("declare") 
      return send(currentCommand)
    end
    # all leftover commands will need a existing list name, except declare
    if ! doesListExist(@command.split(' ')[1])
      return false
    end
    # call the appropriate function, return its value (we already checked if it is a valid command earlier with verifyCommand...)
    commandArr = @command.split(' ',3)
	
    return send(currentCommand, commandArr[1], commandArr[2])


  end
  # private functions...
  private
	def undeclare(listName, args)
		puts "HELLO FFROM UNDECLARE"
		puts listName
		argsArr = args.split(',')
		argsArr.each {|elem| puts elem.strip}
	end
	def declare
		commandArr = @command.split(' ', 3)
		if commandArr.size > 1
			# we have multiple args...
			if doesListExist
	end
    def doesListExist(someListName)
		# eventually, this function will check a hashmap to see if someListName is a key in the map...
      return true
    end
    def upcase
      @IS_UPCASE ? @IS_UPCASE = false : @IS_UPCASE = true
    end
    def add(arr)
      puts "hello from the add function..."
      arr.each {|elem| puts elem}
    end
    def verifyCommand(arg)
      puts "verifing: " + arg
      return true unless ! @validCommands.include?(arg)
      return false
    end
    def clearCommand
      @command = ""
    end
end


def main
  listInt = ListInterpreter.new()
  listInt.setCommand("undeclare LISTNAME THIS, IS, A, LIST, OF, ARGS.....")
  puts listInt.getCommand()
  if (listInt.execute)
    puts "its it is a valid command!"
  else 
    puts "this is invalid..."
  end
end

# call main
main
