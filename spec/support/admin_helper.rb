module AdminHelper
  def sign_in_admin(admin)
    visit admin_dashboard_path
    expect(current_path).to eq(new_admin_session_path)
    within('#new_admin') do
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_button 'Log In'
    end
    expect(current_path).to eq(admin_dashboard_path)
    expect(page).to have_content('Signed in successfully')
  end

  def sign_out_admin(admin)
    visit admin_dashboard_path
    expect(current_path).to eq(admin_dashboard_path)
    click_link 'Sign Out'
    expect(current_path).to eq(root_path)
  end
end
