class ProfessionalLicense < ApplicationRecord
  belongs_to :user
  belongs_to :issuing_authority
end
