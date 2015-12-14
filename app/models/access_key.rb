class AccessKey < ActiveRecord::Base
  validates_presence_of :value, :expires_after
  validates_uniqueness_of :value

  before_validation :downcase_value

  def expired?
    Time.now > expires_after
  end

  def not_expired?
    !expired?
  end

  private

  def downcase_value
    value.downcase! if value
  end
end
