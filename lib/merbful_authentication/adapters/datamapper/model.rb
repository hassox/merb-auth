MA[:user].class_eval do

    include DataMapper::Resource
    include MerbfulAuthentication::Adapters::DataMapperMap
    
    attr_accessor :password, :password_confirmation
    
    property :id,               Integer,  :serial   => true
    property :login,            String,   :nullable => false, :length => 3..40, :unique => true
    property :email,            String
    property :created_at,       DateTime
    property :updated_at,       DateTime
    property :activated_at,     DateTime
    property :activation_code,  String
    property :crypted_password, String
    property :salt,             String
    
    validates_present        :password, :if => proc{|m| m.password_required?}
    validates_is_confirmed   :password, :if => proc{|m| m.password_required?}
    
    before :valid? do
      set_login
    end
    
    before :save,   :encrypt_password
    before :create, :make_activation_code
      
    def login=(value)
      attribute_set(:login, value.downcase) unless value.nil?
    end
  
end