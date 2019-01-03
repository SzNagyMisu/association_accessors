RSpec.configure do |config|
  config.include AssociationAccessors::Test
end

RSpec.describe 'the test matcher' do
  subject { Author.new }

  it 'raises ActiveRecord::AssociationNotFoundError if the association does not exist on subject.' do
    expect {
      should have_association_accessor_for(:book).with_attribute(:serial)
    }.to raise_exception ActiveRecord::AssociationNotFoundError, /Association named 'book' was not found on Author/
  end

  it 'raises ArgumentError if `with_attribute` is blank.' do
    expect {
      should have_association_accessor_for(:books)
    }.to raise_exception ArgumentError, /'with_attribute' is required/
  end

  describe 'for singular association' do
    it 'fails if subject does not respond to the reader or writer `[association]_[attribute]`.' do
      expect {
        should have_association_accessor_for(:address).with_attribute(:uuid)
      }.to raise_exception RSpec::Expectations::ExpectationNotMetError, /reader and\/or writer `address_uuid` not defined on Author/
    end

    it 'passes if subject responds to the reader and writer `[association]_[attribute]`.' do
      should have_association_accessor_for(:address).with_attribute(:serial)
      should have_association_accessor_for(:image).with_attribute(:serial)
      expect(Book.new).to have_association_accessor_for(:author).with_attribute(:serial)
    end
  end

  describe 'for collection association' do
    it 'fails if subject does not respond to the reader or writer `[association_singular]_[attribute_plural]`.' do
      expect {
        should have_association_accessor_for(:chapters).with_attribute(:uuid)
      }.to raise_exception RSpec::Expectations::ExpectationNotMetError, /reader and\/or writer `chapter_uuids` not defined on Author/
    end

    it 'passes if subject responds to the reader and writer `[association_singular]_[attribute_plural]`.' do
      should have_association_accessor_for(:books).with_attribute(:serial)
      should have_association_accessor_for(:chapters).with_attribute(:serial)
      should have_association_accessor_for(:publishers).with_attribute(:uuid)
      expect(Book.new).to have_association_accessor_for(:images).with_attribute(:serial)
    end
  end

  it 'has a concise but expressive default output.' do
    expect(have_association_accessor_for(:books).with_attribute(:serial).description)
      .to eq 'have association accessor for :books with attribute :serial.'
  end
end
