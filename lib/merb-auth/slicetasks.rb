namespace :slices do
  namespace :merb_auth do 
    
    # add your own merb_auth tasks here
    
    # implement this to test for structural/code dependencies
    # like certain directories or availability of other files
    desc "Test for any dependencies"
    task :preflight do
    end
    
    # implement this to perform any database related setup steps
    desc "Migrate the database"
    task :migrate do
    end

    desc "Generate Migration"
    task :generate_migration => :merb_env do
      puts `merb-gen ma_migration #{MA[:user].name}`
    end
    
  end
end