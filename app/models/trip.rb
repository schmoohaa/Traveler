class Trip < ActiveRecord::Base
  validates :name, :presence => true    # Rails3 slightly different validation syntax

  has_many :trip_segments

end



# class Book < ActiveRecord::Base
#     validates :title, :presence => true # Always run
#     validates :proofread, :inclusion => {  :in => [true, false] }, :on => :publish # Skipped on create or update
#
#     def publish!
#       # Note the ":publish" argument on #valid? -- we're telling the model to run validations for the ":publish" context
#       valid?(:publish) && toggle(:published) && save!
#     end
#   end