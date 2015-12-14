module DateHelper
  def pretty_date(date)
    date.strftime('%b. %d, %Y')
  end
end