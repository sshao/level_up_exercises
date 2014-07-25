class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  validates :username, :uniqueness => { :case_sensitive => false }
  validate :unique_sets
  
  has_and_belongs_to_many :palette_sets, join_table: :palette_sets_users

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
     if login = conditions.delete(:login)
       where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
     else
       where(conditions).first
     end
  end

  private
  def unique_sets 
    if palette_sets.uniq.size != palette_sets.size 
      errors.add(:palette_sets, "Palette set already in favorites.")
    end
  end
end
