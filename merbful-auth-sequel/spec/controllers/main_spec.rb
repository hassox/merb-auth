require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbfulAuthSequel::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbfulAuthSequel) } if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbfulAuthSequel::Main, :index)
    controller.slice.should == MerbfulAuthSequel
    controller.slice.should == MerbfulAuthSequel::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbfulAuthSequel::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbfulAuthSequel')
  end
  
  it "should work with the default route" do
    controller = get("/merbful-auth-sequel/main/index")
    controller.should be_kind_of(MerbfulAuthSequel::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbfulAuthSequel::Main, :index)
    controller.public_path_for(:image).should == "/slices/merbful-auth-sequel/images"
    controller.public_path_for(:javascript).should == "/slices/merbful-auth-sequel/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merbful-auth-sequel/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbfulAuthSequel::Main._template_root.should == MerbfulAuthSequel.dir_for(:view)
    MerbfulAuthSequel::Main._template_root.should == MerbfulAuthSequel::Application._template_root
  end

end