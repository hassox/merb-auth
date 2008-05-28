require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbfulAuthentication::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbfulAuthentication) } if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbfulAuthentication::Main, :index)
    controller.slice.should == MerbfulAuthentication
    controller.slice.should == MerbfulAuthentication::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbfulAuthentication::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbfulAuthentication')
  end
  
  it "should work with the default route" do
    controller = get("/merbful_authentication/main/index")
    controller.should be_kind_of(MerbfulAuthentication::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbfulAuthentication::Main, :index)
    controller.public_path_for(:image).should == "/slices/merbful_authentication/images"
    controller.public_path_for(:javascript).should == "/slices/merbful_authentication/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merbful_authentication/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbfulAuthentication::Main._template_root.should == MerbfulAuthentication.dir_for(:view)
    MerbfulAuthentication::Main._template_root.should == MerbfulAuthentication::Application._template_root
  end

end