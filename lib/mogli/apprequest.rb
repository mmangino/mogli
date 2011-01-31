module Mogli
  class Apprequest < Model
    
    define_properties :id, :data, :message, :created_time, :application, :from, :to
    
  end
end