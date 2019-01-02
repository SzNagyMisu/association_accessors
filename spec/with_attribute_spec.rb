RSpec.describe 'the `with_attribute:` key' do
  context 'if default is not set' do
    it 'cannot be nil.' do
      expect { Book.association_accessor_for :chapters }
        .to raise_exception ArgumentError, 'missing keyword: with_attribute'
    end

    it 'can be a string.' do
      expect(Book.new).not_to respond_to :chapter_serials, :chapter_serials=
      expect { Book.association_accessor_for :chapters, with_attribute: 'serial' }.not_to raise_exception
      expect(Book.new).to respond_to :chapter_serials, :chapter_serials=
    end

    it 'can be a symbol.' do
      expect(Book.new).not_to respond_to :chapter_uuids, :chapter_uuids=
      expect { Book.association_accessor_for :chapters, with_attribute: :uuid }.not_to raise_exception
      expect(Book.new).to respond_to :chapter_uuids, :chapter_uuids=
    end
  end

  context 'if default is set' do
    before :all do
      AssociationAccessors.default_attribute = :serial
    end
    after :all do
      AssociationAccessors.default_attribute = nil
    end

    it 'can be nil, and default will be used.' do
      expect(Address.new).not_to respond_to :author_serial, :author_serial=
      expect { Address.association_accessor_for :author }.not_to raise_exception
      expect(Address.new).to respond_to :author_serial, :author_serial=
    end

    it 'can be string to override default' do
      expect(Address.new).not_to respond_to :author_uuid, :author_uuid=
      expect { Address.association_accessor_for :author, with_attribute: 'uuid' }.not_to raise_exception
      expect(Address.new).to respond_to :author_uuid, :author_uuid=
    end

    it 'can be symbol to override default' do
      expect(Address.new).not_to respond_to :author_guuid, :author_guuid=
      expect { Address.association_accessor_for :author, with_attribute: :guuid }.not_to raise_exception
      expect(Address.new).to respond_to :author_guuid, :author_guuid=
    end
  end
end
