require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbfulAuth::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbfulAuth) } if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbfulAuth::Main, :index)
    controller.slice.should == MerbfulAuth
    controller.slice.should == MerbfulAuth::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbfulAuth::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbfulAuth')
  end
  
  it "should work with the default route" do
    controller = get("/merbful-auth/main/index")
    controller.should be_kind_of(MerbfulAuth::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbfulAuth::Main, :index)
    controller.public_path_for(:image).should == "/slices/merbful-auth/images"
    controller.public_path_for(:javascript).should == "/slices/merbful-auth/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merbful-auth/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbfulAuth::Main._template_root.should == MerbfulAuth.dir_for(:view)
    MerbfulAuth::Main._template_root.should == MerbfulAuth::Application._template_root
  end

end