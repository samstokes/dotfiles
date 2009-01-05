require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ${controller}Controller do

  describe "route generation" do

    it "should map {:controller => '${controller}', :action => '${action}', ${moreparams}} to /${controller}/${params}/${action}" do
      route_for(:controller => '${controller}', :action => '${action}', ${moreparams}).
          should == "/${controller}/${params}/${action}"
    end
    
  end

  describe "route recognition" do

    it "should generate params {:controller => '${controller}', :action => '${action}', ${moreparams}} from ${method} /${controller}/${params}/${action}" do
      params_from(:${method}, "/${controller}/${params}/${action}").should == {:controller => '${controller}', :action => '${action}', ${moreparams}}
    end

  end

end
