# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clean up the database before seeding
puts "Cleaning the database..."
User.destroy_all
Organisation.destroy_all
Post.destroy_all
UserOrganisation.destroy_all

# Create sample mining organizations and mining industry associations
puts "Creating mining organizations and associations..."
organisations = [
  # Major mining companies
  { name: "BHP Group", country: "Australia", language: "English" },
  { name: "Rio Tinto", country: "Australia", language: "English" },
  { name: "Fortescue Metals Group", country: "Australia", language: "English" },
  { name: "Newcrest Mining", country: "Australia", language: "English" },
  { name: "South32", country: "Australia", language: "English" },
  { name: "Evolution Mining", country: "Australia", language: "English" },
  { name: "Northern Star Resources", country: "Australia", language: "English" },
  { name: "Mineral Resources", country: "Australia", language: "English" },
  { name: "Whitehaven Coal", country: "Australia", language: "English" },
  { name: "Pilbara Minerals", country: "Australia", language: "English" },
  { name: "Iluka Resources", country: "Australia", language: "English" },
  { name: "Yancoal Australia", country: "Australia", language: "English" },
  { name: "IGO Limited", country: "Australia", language: "English" },
  { name: "Sandfire Resources", country: "Australia", language: "English" },
  { name: "Regis Resources", country: "Australia", language: "English" },
  { name: "OZ Minerals", country: "Australia", language: "English" },
  { name: "Gold Road Resources", country: "Australia", language: "English" },
  { name: "Lynas Rare Earths", country: "Australia", language: "English" },
  { name: "Alumina Limited", country: "Australia", language: "English" },
  { name: "St Barbara", country: "Australia", language: "English" },
  
  # Mining industry associations
  { name: "Minerals Council of Australia", country: "Australia", language: "English" },
  { name: "Association of Mining and Exploration Companies", country: "Australia", language: "English" },
  { name: "Queensland Resources Council", country: "Australia", language: "English" },
  { name: "NSW Minerals Council", country: "Australia", language: "English" },
  { name: "Chamber of Minerals and Energy of WA", country: "Australia", language: "English" },
  { name: "South Australian Chamber of Mines and Energy", country: "Australia", language: "English" },
  { name: "Tasmanian Minerals, Manufacturing and Energy Council", country: "Australia", language: "English" },
  { name: "Australian Aluminium Council", country: "Australia", language: "English" },
  { name: "Australian Mines and Metals Association", country: "Australia", language: "English" },
  { name: "Mining and Energy Union", country: "Australia", language: "English" }
]

created_organisations = organisations.map do |org_data|
  Organisation.create!(org_data)
end

# Create 100 users with password 'admin'
puts "Creating 100 users..."

# First names and last names arrays to randomly generate user data
first_names = [
  "John", "Emma", "Michael", "Sarah", "David", "Jennifer", "Robert", "Jessica", "James", "Linda",
  "Thomas", "Patricia", "Charles", "Margaret", "Christopher", "Nancy", "Daniel", "Elizabeth", "George", "Susan",
  "Matthew", "Karen", "Anthony", "Lisa", "Donald", "Helen", "Mark", "Sandra", "Paul", "Ashley",
  "Steven", "Amanda", "Andrew", "Melissa", "Kenneth", "Stephanie", "Joshua", "Laura", "Kevin", "Rebecca",
  "Brian", "Sharon", "Edward", "Cynthia", "Ronald", "Kathleen", "Jason", "Ruth", "Jeffrey", "Anna"
]

last_names = [
  "Smith", "Johnson", "Brown", "Davis", "Wilson", "Lee", "Miller", "White", "Taylor", "Martinez",
  "Anderson", "Garcia", "Rodriguez", "Wilson", "Moore", "Clark", "Lewis", "Baker", "Wright", "Adams",
  "Jones", "Williams", "Harris", "Thomas", "Jackson", "Martin", "Thompson", "Robinson", "Walker", "Young",
  "Allen", "King", "Scott", "Green", "Mitchell", "Carter", "Turner", "Phillips", "Campbell", "Parker",
  "Evans", "Edwards", "Collins", "Hill", "Morris", "Price", "Bell", "Cooper", "Richardson", "Wood"
]

# Create 100 users with mix of active and departed status
created_users = []
100.times do |i|
  first_name = first_names[i % first_names.length]
  last_name = last_names[i % last_names.length]
  name = "#{first_name} #{last_name}"
  email = "#{first_name.downcase}#{i}@example.com"
  
  # Make 80% active and 20% departed
  status = i < 80 ? "active" : "departed"
  
  created_users << User.create!(
    name: name,
    email: email,
    password: "admin",
    password_confirmation: "admin",
    status: status
  )
end

# Assign users to organizations
puts "Assigning users to organizations..."
created_users.each_with_index do |user, index|
  # Primary organization - distribute evenly
  primary_org = created_organisations[index % created_organisations.length]
  
  # Create primary organization association
  UserOrganisation.create!(
    user: user,
    organisation: primary_org,
    is_primary: true
  )
  
  # 50% chance of having a second organization
  if rand < 0.5
    secondary_org = created_organisations.reject { |org| org == primary_org }.sample
    UserOrganisation.create!(
      user: user,
      organisation: secondary_org,
      is_primary: false
    )
  end
  
  # 25% chance of having a third organization
  if rand < 0.25
    available_orgs = created_organisations.reject do |org| 
      org == primary_org || user.organisations.include?(org)
    end
    if available_orgs.any?
      tertiary_org = available_orgs.sample
      UserOrganisation.create!(
        user: user,
        organisation: tertiary_org,
        is_primary: false
      )
    end
  end
end

# Create posts
puts "Creating posts..."
post_content = [
  "Just completed the quarterly mining production report. We've exceeded our targets by 15%!",
  "New safety protocols being implemented at our South Flank site next month.",
  "Team meeting scheduled for Thursday to discuss the expansion of our Pilbara operations.",
  "Working on optimizing our extraction processes to improve yield rates.",
  "Great brainstorming session today on sustainable mining practices for our upcoming projects.",
  "Environmental impact assessment results are in. All sites are within regulatory compliance.",
  "Remember to submit your site visit reports by the end of the week.",
  "Just updated our geological survey data. New promising deposits identified.",
  "Looking for volunteers for the community outreach program in the Western regions.",
  "New equipment safety training will be implemented starting next Monday. Details in email.",
  "Congratulations to the exploration team for discovering the new mineral deposit!",
  "Don't forget about the industry conference this weekend. Great networking opportunity!",
  "The new reclamation plan is ready for review. Feedback appreciated.",
  "Working remotely tomorrow due to the transportation strike affecting site access.",
  "Happy to announce we've secured the environmental permit for our new project.",
  "Commodity prices are rising - our quarterly projections look promising.",
  "New drilling results from the eastern section show high-grade ore deposits.",
  "Successfully implemented the new tailings management system across all sites.",
  "Looking for input on our indigenous engagement strategy for the northern project.",
  "Maintenance shutdown scheduled for next month - please prepare your departments.",
  "Weather alert: Cyclone warning for northern operations. Safety protocols activated.",
  "Working with government regulators on streamlining the approvals process.",
  "R&D team has developed a new extraction technique that reduces water usage by 30%.",
  "Annual sustainability report published - we've reduced our carbon footprint by 12%.",
  "Exciting developments in autonomous mining technology being tested at our flagship site."
]

# Create 3-8 posts per active user in their primary organization
created_users.select(&:active?).each do |user|
  post_count = rand(3..8)
  primary_org = user.primary_organisation
  
  post_count.times do
    Post.create!(
      description: post_content.sample,
      user: user,
      organisation: primary_org,
      created_at: rand(1..365).days.ago
    )
  end
end

# Create 1-2 posts for departed users (these will be from before they departed)
created_users.select(&:departed?).each do |user|
  post_count = rand(1..2)
  primary_org = user.primary_organisation
  
  post_count.times do
    Post.create!(
      description: post_content.sample,
      user: user,
      organisation: primary_org,
      created_at: rand(180..365).days.ago
    )
  end
end

puts "Seed data created successfully!"
puts "Created #{Organisation.count} mining organizations and associations"
puts "Created #{User.count} users (#{User.active.count} active, #{User.departed.count} departed)"
puts "Created #{Post.count} posts"
puts "Created #{UserOrganisation.count} user-organization relationships"
puts "All users have password 'admin'"
