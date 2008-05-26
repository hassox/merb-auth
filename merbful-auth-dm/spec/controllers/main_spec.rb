require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbfulAuthDm::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbfulAuthDm) } if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbfulAuthDm::Main, :index)
    controller.slice.should == MerbfulAuthDm
    controller.slice.should == MerbfulAuthDm::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbfulAuthDm::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbfulAuthDm')
  end
  
  it "should work with the default route" do
    controller = get("/merbful-auth-dm/main/index")
    controller.should be_kind_of(MerbfulAuthDm::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbfulAuthDm::Main, :index)
    controller.public_path_for(:image).should == "/slices/merbful-auth-dm/images"
    controller.public_path_for(:javascript).should == "/slices/merbful-auth-dm/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merbful-auth-dm/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbfulAuthDm::Main._template_root.should == MerbfulAuthDm.dir_for(:view)
    MerbfulAuthDm::Main._template_root.should == MerbfulAuthDm::Application._template_root
  end

end