namespace :pages do
  desc 'Update the page objects in the database to match the filesystem'
  task scan: [:environment] do
    Rails.logger.info 'Scanning for new static templates...'
    static = Static::Pages.new
    static.persist!
    Rails.logger.info 'Completed scan for templates.'
  end
end
