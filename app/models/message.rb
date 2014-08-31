class Message < ActiveRecord::Base
  attr_accessor :to
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  default_scope -> { order('created_at DESC') }
  before_validation :set_receiver_id
  validates :sender_id, presence: true, numericality: { only_integer: true }
  validates :receiver_id, presence: true, numericality: { only_integer: true }
  validates :content, presence: true, length: { maximum: 1000 }

  private
    def set_receiver_id
      if receiver_id.nil?
        receiver = User.find_by(username: to)
        self.receiver_id = receiver.id unless receiver.nil?
      end
    end
end
