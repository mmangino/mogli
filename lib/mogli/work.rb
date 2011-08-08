module Mogli
  class Work < Model
    
    define_properties :start_date, :end_date, :description, :with, :from
    
    hash_populating_accessor :projects, "Page"
    hash_populating_accessor :employer, "Page"
    hash_populating_accessor :location, "Page"
    hash_populating_accessor :position, "Page"
  end
end