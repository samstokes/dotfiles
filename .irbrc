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


def gvim(*args)
  system("gvim", *args.map(&:to_s))
end

def sql(statement)
  puts ActiveRecord::Base.connection.execute(statement).entries
end
