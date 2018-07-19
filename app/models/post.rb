class Post < ApplicationRecord
  after_create :notify_admin

  belongs_to :user

  validates :title, length: { minimum: 5}
  validates :body, presence: true

  def notify_admin
    PostMailer.new_post_notification(self).deliver
  end
end
