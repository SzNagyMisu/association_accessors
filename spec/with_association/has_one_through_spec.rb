RSpec.describe AssociationAccessors do
  describe 'for `has_one` association' do
    let!(:author)  { Author.create! }
    let!(:book)    { author.books.create! }
    let!(:address) { author.create_address! }

    it 'generates `#[association_name]_[attribute_name]` accessor.' do
      expect(book).to respond_to :address_serial, :address_serial=
    end

    describe '`#[association_name]_[attribute_name]`' do
      it 'returns the value of the `[attribute]` of the associated record if there is any.' do
        expect { book.address = nil }.to change(book, :address_serial).from(address.serial).to nil
      end
    end

    describe '`#[association_name]_[attribute_name]=(value)`' do
      it 'sets the association value to nil if `value` is nil.' do
        expect { book.address_serial = nil }.to change(book, :address).from(address).to nil
      end

      it 'raises ActiveRecord::HasOneThroughCantAssociateThroughHasOneOrManyReflection.' do
        new_address = Address.create!
        expect { book.address_serial = new_address.serial }
          .to raise_exception(ActiveRecord::HasOneThroughCantAssociateThroughHasOneOrManyReflection,
                              %{Cannot modify association 'Book#address' because the source reflection class 'Address' is associated to 'Author' via :has_one.})
      end

      it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.' do
        expect { book.address_serial = address.serial.next }.to raise_exception ActiveRecord::RecordNotFound, "Couldn't find Address"
      end
    end
  end
end
