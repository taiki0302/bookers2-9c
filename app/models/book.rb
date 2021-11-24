class Book < ApplicationRecord
  belongs_to :user, optional: true
  attachment :profile_image
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200}

  def favorited_by?(user)
	favorites.where(user_id: user.id).exists?
  end
  
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_days_ago, ->(n) { where(created_at: n.days.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }   #先週
  
  def Book.search(search, model, how)
    if how == "partical"
  	  Book.where("title LIKE ?", "%#{search}%")
    elsif how == "forward"
  	  Book.where("title LIKE ?", "#{search}%")
    elsif how == "backward"
  	  Book.where("title LIKE ?", "%#{search}")
    elsif how == "match"
  	  Book.where("title LIKE ?", "#{search}")
    end
  end

end