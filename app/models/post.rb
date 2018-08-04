class Post < ApplicationRecord
  after_create :notify_admin

  belongs_to :user
  has_many :comments

  validates :title, length: { minimum: 5}
  validates :body, presence: true

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  has_attached_file :image, styles: { large: "600x600", medium: "300x300", thumb: "150x150"}, :default_url => "http://www.wakaama.co.nz/imagecache?u=http%3A%2F%2Fs3.wakaama.co.nz%2Fstory%2F1001604%2Fphotos%2FMaungatapu_e.jpg&w=200"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def notify_admin
    @subscribers = Subscriber.all

    @subscribers.each do |subscriber|
      PostMailer.new_post_notification(self, subscriber.email).deliver
    end  
  end
end
