# destroy left over
User.destroy_all
List.destroy_all

# --- Users
# create user one day ago
user1 = User.create!(
  id: 1,
  username: 'user1',
  email: 'first@user.de',
  created_at: Time.now - 24.hours,
  password: '..,-mond'
)
user1.skip_confirmation!
user1.confirm
user1.free!
user1.save

# create + confirm + approve user at current time
user2 = User.create!(
  id: 2,
  username: 'user2',
  email: 'second@user.de',
  password: '..,-mond'
)
user2.skip_confirmation!
user2.confirm
user2.free!
user2.save

# --- List
PaperTrail.request.whodunnit = User.first
List.create!(
  id: 1,
  name: 'Apple Ecosystem',
  description: 'Things I own',
  ownable: user2,
  creator: user2
)

PaperTrail.request.whodunnit = Admin.first
List.create!(
  id: 2,
  name: 'Drinks',
  description: 'Non-alcoholic drinks',
  ownable: user1,
  creator: Admin.first
)

PaperTrail.request.whodunnit = Admin.last
List.create!(
  id: 3,
  name: 'TODO',
  description: 'what I need to do here',
  ownable: Admin.first,
  creator: Admin.first
)
