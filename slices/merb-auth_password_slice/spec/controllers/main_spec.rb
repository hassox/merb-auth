require File.dirname(__FILE__) + '/../spec_helper'

describe "MauthPasswordSlice::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MauthPasswordSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MauthPasswordSlice::Main, :index)
    controller.slice.should == MauthPasswordSlice
    controller.slice.should == MauthPasswordSlice::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MauthPasswordSlice::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MauthPasswordSlice')
  end
  
  it "should work with the default route" do
    controller = get("/mauth_password_slice/main/index")
    controller.should be_kind_of(MauthPasswordSlice::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/mauth_password_slice/index.html")
    controller.should be_kind_of(MauthPasswordSlice::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have routes in MauthPasswordSlice.routes" do
    MauthPasswordSlice.routes.should_not be_empty
  end
  
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MauthPasswordSlice::Main, 'index')
    controller.slice_url(:action => 'show', :format => 'html').should == "/mauth_password_slice/main/show.html"
    controller.slice_url(:mauth_password_slice_index, :format => 'html').should == "/mauth_password_slice/index.html"
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MauthPasswordSlice::Main, :index)
    controller.public_path_for(:image).should == "/slices/mauth_password_slice/images"
    controller.public_path_for(:javascript).should == "/slices/mauth_password_slice/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/mauth_password_slice/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MauthPasswordSlice::Main._template_root.should == MauthPasswordSlice.dir_for(:view)
    MauthPasswordSlice::Main._template_root.should == MauthPasswordSlice::Application._template_root
  end

end