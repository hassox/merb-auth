require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Authentication::StrategyContainer do
  
  before(:each) do
    @s = Authentication::StrategyContainer.new
    @mock = mock("mock")
  end
  
  describe "accessors" do
    it "should have order as an array" do
      @s.order.should be_a_kind_of(Array)
    end
    it "should have strategies as a hash" do
      @s.strategies.should be_a_kind_of(Hash)
    end
  end
  
  describe "adding a strategy" do
    it "should add a strategy" do
      @s.add(:my_label){ @mock.one }
      @mock.should_receive(:one)
      @s[:my_label].call
    end
    
    it "should add multiple strategies" do
      @s.add(:number1){ @mock.one }
      @s.add(:number2){ @mock.two }
      @mock.should_receive(:one)
      @mock.should_receive(:two)
      @s[:number1].call
      @s[:number2].call      
    end
    
    it "should add the label to the order" do
      @s.order.should be_empty
      @s.add(:one){@mock.one}
      @s.order.should include(:one)
    end
    
    it "should add each strategy in order" do
      @s.add(:one){@mock.one}
      @s.add(:two){@mock.two}
      @s.order.should == [:one, :two]
    end
    
    it "should raise an error if there is already a strategy with the label defined" do
      @s.add(:one){@mock.one}
      lambda do
        @s.add(:one){@mock.two}
      end.should raise_error(Authentication::DuplicateStrategy)
    end
  end
  
  describe "removing a strategy" do
    before(:each) do
      @s.add(:one){@mock.one}
    end
    
    it "should remove an existing strategy from strategies" do
      @s.remove(:one)
      @s[:one].should be_nil
    end
    
    it "should remove the strategy from the order list when removing it" do
      @s.remove(:one)
      @s.order.should_not include(:one)
    end
    
    it "should return the strategy when removing it" do
      @s.remove(:one).should be_a_kind_of(Proc)
    end
    
    it "should raise an error if a strategy is removed that doesn't exist" do
      lambda do
        @s.remove(:does_not_exist)
      end.should raise_error(Authentication::MissingStrategy)
    end
  end
  
  describe "changing order" do
    before(:each) do
      @s.add(:one){@mock.one}
      @s.add(:two){@mock.two}
      @s.add(:three){@mock.three}
    end
    
    it "should raise an error if the item is not an array" do
      lambda do
        @s.order = {:one => :two}
      end.should raise_error
    end
    
    it "should have added them in order" do
      @s.order.should == [:one, :two, :three]
    end
    
    it "should return the array" do
      (@s.order = [:one, :two, :three]).should == [:one, :two, :three]
    end
    
    it "should allow reordering of all items" do
      @s.order = [:three, :one, :two]
      @s.order.should == [:three, :one, :two]
    end
    
    it "should allow reordering of a sub-set of items" do
      @s.order = [:three, :two]
      @s.order.should == [:three, :two]
    end
    
    it "should raise an error if there is an item that does not exist" do
      lambda do
        @s.order = [:five]
      end.should raise_error(Authentication::MissingStrategy)
    end    
    
    it "should raise an error if there is duplicate sttrategies" do
      lambda do
        @s.order = [:three, :two, :three]
      end.should raise_error(Authentication::DuplicateStrategy)
    end
  end
  
  describe "iterating over strategies" do
    before(:each) do
      @s.add(:one){@mock.one}
      @s.add(:two){@mock.two}
      @s.add(:three){@mock.three}
      @s.add(:four){@mock.four}
      @s.add(:five){@mock.five}
    end
    
    it "should iterate over the strategies listed in order" do
      @s.order.each do |s|
        @mock.should_receive(s).once.ordered
      end
      @s.each{|strategy| strategy.call}      
    end
    
    it "should iterate over the strategies given in a new order" do
      order = [:three, :two, :five, :one, :four]
      @s.order = order
      order.each do |label|
        @mock.should_receive(label).once.ordered
      end
      @s.each{|s| s.call}            
    end
    
    it "should itereate over the order with a sub set of available itmes" do
      order = [:three, :four, :one]
      @s.order = order
      order.each do |label|
        @mock.should_receive(label).once.ordered
      end
      @s.each{|s| s.call}
    end
  end
  
  describe "clear!" do
    before(:each) do
      @s.add(:one){@mock.one}
      @s.add(:two){@mock.two}
      @s.add(:three){@mock.three}
      @s.add(:four){@mock.four}
      @s.add(:five){@mock.five}
    end
    
    it "should clear the strategies" do
      @s.clear!
      @s.strategies.should be_empty
    end
    
    it "should clear the order" do
      @s.clear!
      @s.order.should be_empty
    end
  end
  
end