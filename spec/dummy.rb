require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :authors, force: true do |t|
    t.string :serial
  end

  create_table :books, force: true do |t|
    t.string :serial
    t.integer :author_id
  end

  create_table :addresses, force: true do |t|
    t.string :serial
    t.integer :author_id
  end

  create_table :chapters, force: true do |t|
    t.string :serial
    t.integer :book_id
  end

  create_table :publishers, force: true do |t|
    t.string :uuid
  end

  create_join_table :authors, :publishers

  create_table :images, force: true do |t|
    t.string :serial
    t.string :imageable_type
    t.integer :imageable_id
  end
end

class Serialable < ActiveRecord::Base
  include AssociationAccessors
  self.abstract_class = true
  before_create do
    send :serial=, SecureRandom.urlsafe_base64
  end
end

class Author < Serialable
  has_many :books
  association_accessor_for :books, with_attribute: :serial

  has_one :address
  association_accessor_for :address, with_attribute: :serial

  has_many :chapters, through: :books
  association_accessor_for :chapters, with_attribute: :serial

  has_and_belongs_to_many :publishers
  association_accessor_for :publishers, with_attribute: :uuid

  has_one :image, as: :imageable
  association_accessor_for :image, with_attribute: :serial
end

class Book < Serialable
  belongs_to :author, optional: true
  association_accessor_for :author, with_attribute: :serial

  belongs_to :writer, optional: true, class_name: 'Author', foreign_key: :author_id
  association_accessor_for :writer, with_attribute: :serial

  has_one :address, through: :author
  association_accessor_for :address, with_attribute: :serial

  has_many :images, as: :imageable
  association_accessor_for :images, with_attribute: :serial

  has_many :chapters
end

class Address < Serialable
  belongs_to :author
end

class Chapter < Serialable
  belongs_to :book
end

class Publisher < ActiveRecord::Base
  has_and_belongs_to_many :authors
  before_create do
    send :uuid=, SecureRandom.uuid
  end
end

class Image < Serialable
  belongs_to :imageable, polymorphic: true
  association_accessor_for :imageable, with_attribute: :serial
end
