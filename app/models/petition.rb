class Petition < ApplicationRecord
  belongs_to :user
  has_many :signatures, dependent: :destroy
  has_one_attached :attachment
  # Action Text for rich text fields
  has_rich_text :description
  has_rich_text :justification

  validates :title, presence: true
  validates :description, presence: true
  validates :recipient, presence: true
  validates :petition_type, presence: true
  validates :signature_goal, numericality: { only_integer: true, greater_than: 0 }
  validates :gdpr_consent, acceptance: true
  validates :privacy_policy, acceptance: true

  enum status: { pending: 0, under_review: 1, approved: 2, rejected: 3 }
  enum petition_type: { individual: 0, group_petition: 1, organizational: 2, public_interest: 3 }


  MIN_SIGNATURES_FOR_REVIEW = 100

  def ready_for_review?
    signatures_count >= MIN_SIGNATURES_FOR_REVIEW
  end


  def requires_signatures?
    group_petition? || organizational?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "category", "status", "created_at", "updated_at", "user_id", "description"]
  end
end