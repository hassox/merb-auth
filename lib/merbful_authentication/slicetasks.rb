$SLICED_APP=true # we're running inside the host application context

namespace :slices do
  namespace :merbful_authentication do 
    
    # add your own merbful_authentication tasks here
    
    # implement this to test for structural/code dependencies
    # like certain directories or availability of other files
    desc "Test for any dependencies"
    task :preflight do
    end
    
    # implement this to perform any database related setup steps
    desc "Migrate the database"
    task :migrate do
    end
    
  end
end