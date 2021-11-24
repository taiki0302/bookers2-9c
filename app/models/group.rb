class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true
  validates :introduction, presence: true
  attachment :image, destroy: false
  
  def Group.search(search, model, how)
    if how == "partical"
  	  Group.where("name LIKE ?", "%#{search}%")
    elsif how == "forward"
  	  Group.where("name LIKE ?", "#{search}%")
    elsif how == "backward"
  	  Group.where("name LIKE ?", "%#{search}")
    elsif how == "match"
  	  Group.where("name LIKE ?", "#{search}")
    end
  end
end
