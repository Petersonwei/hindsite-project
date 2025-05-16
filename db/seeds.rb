# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Organisations
organisations = [
  { name: 'Acme Corp', country: 'United States', language: 'English' },
  { name: 'Tech Innovators', country: 'Canada', language: 'English' },
  { name: 'Global Solutions', country: 'United Kingdom', language: 'English' },
  { name: 'Digital Future', country: 'Germany', language: 'German' },
  { name: 'Creative Industries', country: 'France', language: 'French' }
]

organisations.each do |org_attributes|
  Organisation.find_or_create_by!(org_attributes)
end

puts "Created #{Organisation.count} organisations"

# Create Users
if User.count == 0
  # Create users with organisations
  Organisation.all.each do |org|
    2.times do |i|
      User.create!(
        name: "User #{i+1} at #{org.name}",
        email: "user#{i+1}@#{org.name.downcase.gsub(' ', '')}.com",
        password: 'password123',
        organisation: org
      )
    end
  end
  
  # Create a user without an organisation
  User.create!(
    name: "Unaffiliated User",
    email: "unaffiliated@example.com",
    password: 'password123',
    organisation: nil
  )
  
  puts "Created #{User.count} users"
end

# Create Posts
if Post.count == 0
  User.where.not(organisation_id: nil).each do |user|
    2.times do |i|
      Post.create!(
        description: "This is post #{i+1} by #{user.name}. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nisl eget ultricies aliquam, nunc nisl aliquet nunc, vitae aliquam nisl nunc vitae nisl.",
        user: user
      )
    end
  end
  
  puts "Created #{Post.count} posts"
end
