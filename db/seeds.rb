# ------------------------------------------------------------------- Base Users
admin = Admin.find_or_create_by_email(
              :name => ENV['ADMIN_NAME'].dup,
              :email => ENV['ADMIN_EMAIL'].dup,
              :password => ENV['ADMIN_PASSWORD'].dup,
              :password_confirmation => ENV['ADMIN_PASSWORD'].dup
            )
admin.role='admin'
# admin.confirmed_at = DateTime.now
admin.save

# if Rails.env == "development"
#   user = User.find_or_create_by_email(
#               :name => "Test User", :email => "ciccio.pasticcio@gmail.com",
#               :password => ENV['ADMIN_PASSWORD'].dup,
#               :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#             )
#   user.confirmed_at = DateTime.now
#   user.save
# end

puts "Seed done. Remember to run the following maintenance rake tasks:"
puts "rake legacy_import"
puts "rake cleanup_books "
puts "rake isbnmerge"
