require File.dirname(__FILE__) + '/spec_helper'

describe "MerbfulAuth (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbfulAuth)
  end
  
  it "should have an :identifier property" do
    MerbfulAuth.identifier.should == "merbful-auth"
  end
  
  it "should have an :identifier_sym property" do
    MerbfulAuth.identifier_sym.should == :merbful_auth
  end
  
  it "should have a :root property" do
    MerbfulAuth.root.should == current_slice_root
    MerbfulAuth.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have metadata properties" do
    MerbfulAuth.description.should == "MerbfulAuth is a chunky Merb slice!"
    MerbfulAuth.version.should == "0.0.1"
    MerbfulAuth.author.should == "YOUR NAME"
  end
  
  it "should have a config property (Hash)" do
    MerbfulAuth.config.should be_kind_of(Hash)
  end
  
  it "should have a :layout config option set" do
    MerbfulAuth.config[:layout].should == :merbful_auth
  end
  
  it "should have a dir_for method" do
    app_path = MerbfulAuth.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuth.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuth.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuth.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MerbfulAuth.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'merbful-auth'
    app_path = MerbfulAuth.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuth.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuth.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'merbful-auth'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuth.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbfulAuth.public_dir_for(:public)
    public_path.should == '/slices' / 'merbful-auth'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuth.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MerbfulAuth.mirrored_components & MerbfulAuth.slice_paths.keys).length.should == MerbfulAuth.mirrored_components.length
  end
  
end