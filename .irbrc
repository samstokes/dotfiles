require 'irb/completion'
IRB.conf[:AUTO_INDENT] = true

def git(command, *args)
  system("git", command.to_s, *args.map(&:to_s))
end

def gst(*args); git :status, *args; end
def gdf(*args); git :diff, *args; end
def gad(*args); git :add, *args; end
def gap(*args); git :add, "-p", *args; end
def gci(*args); git :commit, *args; end
def gcim(message, *args); git :commit, "-m", message, *args; end
def gciam(message, *args); git :commit, "-a", "-m", message, *args; end
def gciav(*args); git :commit, "-a", "-v", *args; end
def gciv(*args); git :commit, "-v", *args; end


def vim(*args)
  require 'rubygems'
  require 'interactive_editor'
  vi(*args)
end

def gvim(*args)
  system("gvim", *args.map(&:to_s))
end

def sql(statement)
  puts ActiveRecord::Base.connection.execute(statement).entries
end


def methods_returning(answer, *args)
  # probably want to filter out some methods
  # e.g. ones that mutate their receiver...
  blacklist = %w()

  (methods - blacklist).select do |method|
    guinea_pig = begin
                   clone
                 rescue TypeError => e
                   raise unless e.message =~ /can't clone/
                   self
                 end
    begin
      guinea_pig.send(method, *args) == answer
    rescue ArgumentError, LocalJumpError
    rescue TypeError, NoMethodError, NameError, IndexError => e
      args_inspected = args.inspect
      args_nice = args_inspected[1, args_inspected.length - 2]
      puts "#{self.inspect}.#{method}(#{args_nice}) throws #{e.class}: #{e}"
    end
  end
end

def methods_like(pattern)
  methods.grep(/^.*#{pattern}.*$/i)
end

public :methods_returning, :methods_like
