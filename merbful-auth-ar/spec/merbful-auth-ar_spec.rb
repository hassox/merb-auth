require File.dirname(__FILE__) + '/spec_helper'

describe "MerbfulAuthAr (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbfulAuthAr)
  end
  
  it "should have an :identifier property" do
    MerbfulAuthAr.identifier.should == "merbful-auth-ar"
  end
  
  it "should have an :identifier_sym property" do
    MerbfulAuthAr.identifier_sym.should == :merbful_auth_ar
  end
  
  it "should have a :root property" do
    MerbfulAuthAr.root.should == current_slice_root
    MerbfulAuthAr.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have metadata properties" do
    MerbfulAuthAr.description.should == "MerbfulAuthAr is a chunky Merb slice!"
    MerbfulAuthAr.version.should == "0.0.1"
    MerbfulAuthAr.author.should == "YOUR NAME"
  end
  
  it "should have a config property (Hash)" do
    MerbfulAuthAr.config.should be_kind_of(Hash)
  end
  
  it "should have a :layout config option set" do
    MerbfulAuthAr.config[:layout].should == :merbful_auth_ar
  end
  
  it "should have a dir_for method" do
    app_path = MerbfulAuthAr.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuthAr.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuthAr.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthAr.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MerbfulAuthAr.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'merbful-auth-ar'
    app_path = MerbfulAuthAr.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbfulAuthAr.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbfulAuthAr.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'merbful-auth-ar'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthAr.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbfulAuthAr.public_dir_for(:public)
    public_path.should == '/slices' / 'merbful-auth-ar'
    [:stylesheet, :javascript, :image].each do |type|
      MerbfulAuthAr.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MerbfulAuthAr.mirrored_components & MerbfulAuthAr.slice_paths.keys).length.should == MerbfulAuthAr.mirrored_components.length
  end
  
end