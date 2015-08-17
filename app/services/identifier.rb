
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
class Identifier
  def initialize auth, user=nil
    @auth = Hashie::Mash.new auth
    @user = user
  end

  def resolve
    identity = find_or_create_identity
    user     = ensure_user identity
    link identity, user
    user
  end

private

  def find_or_create_identity
    Identity.where(provider: @auth.provider, uid: @auth.uid).
      create_with(auth_data: @auth).
      first_or_create!
  end

  def ensure_user identity
    @user ||= identity.user
    return @user if @user

    @user = User.where(email: identity.email).
      create_with(
        name:      identity.name,
        password:  Devise.friendly_token[0,20]
      ).first_or_create!
  end

  def link identity, user
    identity.update_attribute :user, user unless identity.user == user
  end
end