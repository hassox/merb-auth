module MerbfulAuthentication
  
  # Clears the currently registered adapter list.  
  def self.clear_adapter_list!
    @_adapters = nil
  end
  
  # Registers
  def self.register_adapter(name, path, opts = {})
    adapters[name.to_sym] = opts.merge!(:path => path)
  end
  
  def self.adapters
    @_adapters ||= Hash.new{|h,k| h[k] = {}}
  end
  
  def self.load_adapter!(adapter = nil)
    adapter ||= Merb::Slices::config[:merbful_authentication][:adapter] || Merb.orm_generator_scope
    raise "MerbfulAuthentication: No Adapter Specified" if adapter.nil? || adapter.blank?
    
    # Check that the adapter is registered
    raise "MerbfulAuthentication: Adapter Not Registered - #{adapter}" unless adapters.keys.include?(adapter.to_sym)
    Dir[adapters[adapter.to_sym][:path] / "**" / "*.rb"].each do |f|
      load f
    end
  end
  
  private 
  def self.remove_default_model_klass!
    if defined?(MA::Model)
      MA.module_eval do
        remove_const("Model")
      end
    end
  end
end