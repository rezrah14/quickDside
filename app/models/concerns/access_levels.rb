module AccessLevels
  extend ActiveSupport::Concern

  included do
    enum access_level: { user: 0, admin: 1, owner: 2 }
  end
end
