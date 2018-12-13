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
end

class ApplicationRecord < ActiveRecord::Base
  include AssociationAccessors
  self.abstract_class = true
  before_create do
    send :serial=, SecureRandom.urlsafe_base64
  end
end

class Author < ApplicationRecord
  has_many :books
  association_accessor_for :books, with_attribute: :serial
end

class Book < ApplicationRecord
  belongs_to :author, optional: true
  association_accessor_for :author, with_attribute: :serial
end
