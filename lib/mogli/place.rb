
module Mogli
  class Place < Model
    
    define_properties :id, :name, :category, :username, :can_post, :phone, :website, :checkins, :link, :public_transit, :likes, :picture
    hash_populating_accessor_with_default_field :location, "street", "Address"
    hash_populating_accessor :restaurant_services, "RestaurantServices"
    hash_populating_accessor :restaurant_specialties, "RestaurantSpecialties"
    hash_populating_accessor :parking, "Parking"
    hash_populating_accessor :payment_options, "PaymentOptions"
    hash_populating_accessor :hours, "Hours"
  end
  
  class RestaurantServices < Model
    define_properties :groups, :catering, :waiter, :kids, :outdoor, :reserve, :walkins, :delivery, :takeout
  end

  class RestaurantSpecialties < Model
    define_properties :drinks, :coffee, :breakfast, :dinner, :lunch
  end

  class Parking < Model
    define_properties :valet, :street, :lot
  end

  class PaymentOptions < Model
    define_properties :mastercard, :amex, :cash_only, :visa, :discover
  end

  class Hours < Model
    define_properties :sun_1_open, :sun_1_close, :sun_2_open, :sun_2_close
    define_properties :mon_1_open, :mon_1_close, :mon_2_open, :mon_2_close
    define_properties :tue_1_open, :tue_1_close, :tue_2_open, :tue_2_close
    define_properties :wed_1_open, :wed_1_close, :wed_2_open, :wed_2_close
    define_properties :thu_1_open, :thu_1_close, :thu_2_open, :thu_2_close
    define_properties :fri_1_open, :fri_1_close, :fri_2_open, :fri_2_close
    define_properties :sat_1_open, :sat_1_close, :sat_2_open, :sat_2_close
  end

end