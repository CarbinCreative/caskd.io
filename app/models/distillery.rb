# encoding: utf-8
class Distillery < ActiveRecord::Base

  extend FriendlyId
  include Tokenizable
  include Searchable

  acts_as_persistent

  validates :token,
    on: :update,
    presence: true,
    uniqueness: true,
    length: { is: 8 }

  validates :name,
    presence: true,
    length: { in: 2..64 }

  validates :title,
    presence: true,
    length: { in: 2..64 }

  validates :slug,
    presence: true,
    uniqueness: true,
    slug: true,
    length: { in: 3..128 }

  validates :status,
    presence: true

  validates :state,
    presence: true

  enum status: [
    :operational,
    :inoperative,
    :rebuilding,
    :dormant
  ]

  enum state: [
    :draft,
    :published,
    :flagged
  ]

  friendly_id :slug,
    use: [ :slugged, :finders, :scoped ],
    scope: [ :discarded ]

  searchable_through :title, :name

  scope :operational, -> { where(status: "operational") }
  scope :inoperative, -> { where(status: "inoperative") }
  scope :dormant, -> { where(status: "dormant") }

  scope :drafts, -> { where(state: "draft") }
  scope :published, -> { where(state: "published") }
  scope :flagged, -> { where(state: "flagged") }

end
