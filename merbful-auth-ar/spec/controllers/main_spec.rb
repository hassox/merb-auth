require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbfulAuthAr::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbfulAuthAr) } if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbfulAuthAr::Main, :index)
    controller.slice.should == MerbfulAuthAr
    controller.slice.should == MerbfulAuthAr::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbfulAuthAr::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbfulAuthAr')
  end
  
  it "should work with the default route" do
    controller = get("/merbful-auth-ar/main/index")
    controller.should be_kind_of(MerbfulAuthAr::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbfulAuthAr::Main, :index)
    controller.public_path_for(:image).should == "/slices/merbful-auth-ar/images"
    controller.public_path_for(:javascript).should == "/slices/merbful-auth-ar/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merbful-auth-ar/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbfulAuthAr::Main._template_root.should == MerbfulAuthAr.dir_for(:view)
    MerbfulAuthAr::Main._template_root.should == MerbfulAuthAr::Application._template_root
  end

end