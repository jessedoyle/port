namespace :admin do
  desc 'create an administrator account'
  task :create, [:email, :password, :confirmation] => :environment do |task, args|
    args.confirmation ||= args.password
    admin = Admin.new(email: args.email, password: args.password, password_confirmation: args.confirmation)
    if admin.save
      Rails.logger.info 'New admin account created!'
      puts 'Successfully created new admin account.'
    else
      puts 'Could not create admin account:'
      admin.errors.full_messages.each do |err|
        puts "  " + err
      end
    end
  end
end
