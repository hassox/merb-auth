require File.dirname(__FILE__) + '/spec_helper'

describe "MerbfulAuthSequel (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbfulAuthSequel)
  end
  
  it "should have an :identifier property" do
    MerbfulAuthSequel.identifier.should == "merbful-auth-sequel"
  end
  
  it "should have an :identifier_sym property" do
    MerbfulAuthSequel.identifier_sym.should == :merbful_auth_sequel
  end
  
  it "should have a :root property" do
    MerbfulAuthSequel.root.should == current_slice_root
    MerbfulAuthSequel.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have metadata properties" do
    MerbfulAuthSequel.description.should == "MerbfulAuthSequel is a chunky Merb slice!"
    MerbfulAuthSequel.version.should == "0.0.1"
    MerbfulAuthSequel.author.should == "YOUR NAME"
  end
  
  it "should have a config property (Hash)" do
    MerbfulAuthSequel.config.should be_kind_of(Hash)
  end
  
  it "should have a :layout config option set" do
    MerbfulAuthSequel.config[:layout].should == :merbful_auth_sequel
  end
  
  it "should have a dir_for method" do
    app_path = MerbfulAuthSequel.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuthSequel.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuthSequel.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthSequel.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MerbfulAuthSequel.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'merbful-auth-sequel'
    app_path = MerbfulAuthSequel.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuthSequel.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuthSequel.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'merbful-auth-sequel'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthSequel.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbfulAuthSequel.public_dir_for(:public)
    public_path.should == '/slices' / 'merbful-auth-sequel'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthSequel.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MerbfulAuthSequel.mirrored_components & MerbfulAuthSequel.slice_paths.keys).length.should == MerbfulAuthSequel.mirrored_components.length
  end
  
end