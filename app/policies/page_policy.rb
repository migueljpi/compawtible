class PagePolicy < ApplicationPolicy
  def home?
    true
  end

  def search?
    true
  end

  def other_matches?
    true
  end
end
