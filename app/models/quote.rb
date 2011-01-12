class Quote < ActiveRecord::Base
   belongs_to :cargos
   belongs_to :trucks

end
