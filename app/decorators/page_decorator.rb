class PageDecorator < Draper::Decorator
  delegate_all

  def other_visibility
    public ? 'Private' : 'Public'
  end

  def visibility
    public ? 'Public' : 'Private'
  end
end