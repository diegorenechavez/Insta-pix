# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  bio             :text
#  first_name      :string           not null
#  last_name       :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord 
   validates :email, :password_digest, :session_token, :username, presence:true, uniqueness: true 
   validates :first_name, :last_name, presence: true 
   validates :password, length:{minimum: 6}, allow_nil: true 

   after_initialize :ensure_session_token
   attr_reader :password

   def self.find_by_credentials(username, password)
    user = User.find_by(username)
    if user && user.is_password?(password)
        return user
    else 
        return nil
    end 
   end 

   def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
   end 

   def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
   end 

   def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
   end 

   private

   def ensure_session_token
     generate_unique_session_token unless self.session_token
   end
 
   def new_session_token
     SecureRandom.urlsafe_base64
   end
 
   def generate_unique_session_token
     self.session_token = new_session_token
     while User.find_by(session_token: self.session_token)
       self.session_token = new_session_token
     end
     self.session_token
   end





end 
