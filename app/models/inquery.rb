class Inquery < ActiveRecord::Base
  belongs_to :trucks
  belongs_to :cargos

end
