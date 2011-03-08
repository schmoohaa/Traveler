class Trip < ActiveRecord::Base
  validates :name, :presence => true    # Rails3 slightly different validation syntax

  has_many :trip_segments

end