require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ${Model}SpecHelper

  def ${model}_valid_attributes
    {
      :${attribute} => ${value}
    }
  end

end


describe ${Model} do

  include ${Model}SpecHelper

  before(:each) do
    @${model} = ${Model}.new(${model}_valid_attributes)
  end

  it "should be valid when created with valid attributes" do
    @${model}.should be_valid
  end

end
