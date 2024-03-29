class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, uniqueness: true, presence: true, length: { minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50 }

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  attachment :profile_image, destroy: false
  
  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  # フォローしたときの処理
def follow(user_id)
  relationships.create(followed_id: user_id)
end
# フォローを外すときの処理
def unfollow(user_id)
  relationships.find_by(followed_id: user_id).destroy
end

# フォローしているか判定
def following?(user)
  followings.include?(user)
end

def User.search(search, model, how)
    if model == "user"
      if how == "partical"
        User.where("name LIKE ?", "%#{search}%")
      elsif how == "forward"
        User.where("name LIKE ?", "#{search}%")
      elsif how == "backward"
        User.where("name LIKE?", "%#{search}")
      elsif how == "match"
        User.where("name LIKE?", "#{search}")
      end
    end
end
  
end
