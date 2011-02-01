module Mogli
  class AppRequest < Model
    
    define_properties :id, :data, :message, :created_time
    hash_populating_accessor :application, "Application"
    hash_populating_accessor :from, "Profile"
    hash_populating_accessor :to, "Profile"
    
  end
end