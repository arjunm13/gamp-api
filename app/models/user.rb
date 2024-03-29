require 'digest'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongoid2

   # filters
  before_create :encrypt_password

  # fields
  field :name, type: String
  field :email, type: String
  field :password, type: String, default: '1234'
  field :phone, type: String
  field :address, type: String
  field :description, type: String
  field :keywords, type: Array, default: []
  field :role, type: String, default: 'user'
  field :logo, type: String, default: 'url to default logo'

  # relations
  has_many :reviews, inverse_of: :customer, class_name: 'Review'
  has_many :opinions, inverse_of: :reviewer, class_name: 'Review'
  has_many :promotions
  has_one  :session

  # sunspot
  searchable do
    
    text :name, :email, :description, :keywords, :address

  end

  # validaters
  validates_uniqueness_of :name, :email
  validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def get_id
    self.id.to_s
  end

  # add keyword to user
  def add_keyword(keyword)
    if self.keywords.include?(keyword)
      self.errors.add :keywords, 'could not have duplicate values'
      # return false if an error added
      return false
    else
      self.push(keywords: keyword)
    end
  end

  # see if passworkd matches or not
  def password_match?(password)
  	self.password == Digest::SHA2.hexdigest(password)
  end

  private
  	# encrypt password 
  	def encrypt_password
  		self.password = Digest::SHA2.hexdigest(self.password)
  	end

end
