require File.join(File.dirname(__FILE__), "..", "helper")
require_all_steps

with_steps_for :${steps} do
  run __FILE__.gsub(/\.rb$/, ".story"), :type => RailsStory
end
