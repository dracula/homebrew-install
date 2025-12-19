# frozen_string_literal: true

# Replace active_support titlecase method
class String
  def titlecase
    split.map(&:capitalize).join " "
  end

  def to_p = Pathname self
end
