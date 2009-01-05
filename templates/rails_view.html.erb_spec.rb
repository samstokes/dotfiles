require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "${controller}/${template}" do
  include ${Controller}Helper

  def do_it
    render "${controller}/${template}"
  end

end
