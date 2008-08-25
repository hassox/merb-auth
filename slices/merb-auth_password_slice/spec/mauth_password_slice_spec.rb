require File.dirname(__FILE__) + '/spec_helper'

describe "MauthPasswordSlice (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MauthPasswordSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MauthPasswordSlice)
  end
  
  it "should be registered in Merb::Slices.paths" do
    Merb::Slices.paths[MauthPasswordSlice.name].should == current_slice_root
  end
  
  it "should have an :identifier property" do
    MauthPasswordSlice.identifier.should == "mauth_password_slice"
  end
  
  it "should have an :identifier_sym property" do
    MauthPasswordSlice.identifier_sym.should == :mauth_password_slice
  end
  
  it "should have a :root property" do
    MauthPasswordSlice.root.should == Merb::Slices.paths[MauthPasswordSlice.name]
    MauthPasswordSlice.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have a :file property" do
    MauthPasswordSlice.file.should == current_slice_root / 'lib' / 'mauth_password_slice.rb'
  end
  
  it "should have metadata properties" do
    MauthPasswordSlice.description.should == "MauthPasswordSlice is a chunky Merb slice!"
    MauthPasswordSlice.version.should == "0.0.1"
    MauthPasswordSlice.author.should == "YOUR NAME"
  end
  
  it "should have :routes and :named_routes properties" do
    MauthPasswordSlice.routes.should_not be_empty
    MauthPasswordSlice.named_routes[:mauth_password_slice_index].should be_kind_of(Merb::Router::Route)
  end

  it "should have an url helper method for slice-specific routes" do
    MauthPasswordSlice.url(:controller => 'main', :action => 'show', :format => 'html').should == "/mauth_password_slice/main/show.html"
    MauthPasswordSlice.url(:mauth_password_slice_index, :format => 'html').should == "/mauth_password_slice/index.html"
  end
  
  it "should have a config property (Hash)" do
    MauthPasswordSlice.config.should be_kind_of(Hash)
  end
  
  it "should have bracket accessors as shortcuts to the config" do
    MauthPasswordSlice[:foo] = 'bar'
    MauthPasswordSlice[:foo].should == 'bar'
    MauthPasswordSlice[:foo].should == MauthPasswordSlice.config[:foo]
  end
  
  it "should have a :layout config option set" do
    MauthPasswordSlice.config[:layout].should == :mauth_password_slice
  end
  
  it "should have a dir_for method" do
    app_path = MauthPasswordSlice.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MauthPasswordSlice.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MauthPasswordSlice.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MauthPasswordSlice.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MauthPasswordSlice.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'mauth_password_slice'
    app_path = MauthPasswordSlice.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MauthPasswordSlice.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MauthPasswordSlice.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'mauth_password_slice'
    [:stylesheet, :javascript, :image].each do |type|
      MauthPasswordSlice.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MauthPasswordSlice.public_dir_for(:public)
    public_path.should == '/slices' / 'mauth_password_slice'
    [:stylesheet, :javascript, :image].each do |type|
      MauthPasswordSlice.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_path_for method" do
    public_path = MauthPasswordSlice.public_dir_for(:public)
    MauthPasswordSlice.public_path_for("path", "to", "file").should == public_path / "path" / "to" / "file"
    [:stylesheet, :javascript, :image].each do |type|
      MauthPasswordSlice.public_path_for(type, "path", "to", "file").should == public_path / "#{type}s" / "path" / "to" / "file"
    end
  end
  
  it "should have a app_path_for method" do
    MauthPasswordSlice.app_path_for("path", "to", "file").should == MauthPasswordSlice.app_dir_for(:root) / "path" / "to" / "file"
    MauthPasswordSlice.app_path_for(:controller, "path", "to", "file").should == MauthPasswordSlice.app_dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should have a slice_path_for method" do
    MauthPasswordSlice.slice_path_for("path", "to", "file").should == MauthPasswordSlice.dir_for(:root) / "path" / "to" / "file"
    MauthPasswordSlice.slice_path_for(:controller, "path", "to", "file").should == MauthPasswordSlice.dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MauthPasswordSlice.mirrored_components & MauthPasswordSlice.slice_paths.keys).length.should == MauthPasswordSlice.mirrored_components.length
  end
  
end