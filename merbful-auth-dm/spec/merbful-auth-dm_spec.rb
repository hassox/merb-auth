require File.dirname(__FILE__) + '/spec_helper'

describe "MerbfulAuthDm (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbfulAuthDm)
  end
  
  it "should have an :identifier property" do
    MerbfulAuthDm.identifier.should == "merbful-auth-dm"
  end
  
  it "should have an :identifier_sym property" do
    MerbfulAuthDm.identifier_sym.should == :merbful_auth_dm
  end
  
  it "should have a :root property" do
    MerbfulAuthDm.root.should == current_slice_root
    MerbfulAuthDm.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have metadata properties" do
    MerbfulAuthDm.description.should == "MerbfulAuthDm is a chunky Merb slice!"
    MerbfulAuthDm.version.should == "0.0.1"
    MerbfulAuthDm.author.should == "YOUR NAME"
  end
  
  it "should have a config property (Hash)" do
    MerbfulAuthDm.config.should be_kind_of(Hash)
  end
  
  it "should have a :layout config option set" do
    MerbfulAuthDm.config[:layout].should == :merbful_auth_dm
  end
  
  it "should have a dir_for method" do
    app_path = MerbfulAuthDm.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuthDm.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuthDm.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthDm.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MerbfulAuthDm.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'merbful-auth-dm'
    app_path = MerbfulAuthDm.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuthDm.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuthDm.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'merbful-auth-dm'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthDm.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbfulAuthDm.public_dir_for(:public)
    public_path.should == '/slices' / 'merbful-auth-dm'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthDm.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MerbfulAuthDm.mirrored_components & MerbfulAuthDm.slice_paths.keys).length.should == MerbfulAuthDm.mirrored_components.length
  end
  
end