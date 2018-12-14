RSpec.describe AssociationAccessors do
  describe 'for `has_one` association' do
    let!(:author)  { Author.create! }
    let!(:address) { Address.create! author: author }

    it 'generates `#[association_name]_[attribute_name]` accessor.' do
      expect(author).to respond_to :address_serial, :address_serial=
    end

    describe '`#[association_name]_[attribute_name]`' do
      it 'returns the value of the `[attribute]` of the associated record if there is any.' do
        expect { author.address = nil }.to change(author, :address_serial).from(address.serial).to nil
      end
    end

    describe '`#[association_name]_[attribute_name]=(value)`' do
      it 'sets the association value to nil if `value` is nil.' do
        expect { author.address_serial = nil }.to change(author, :address).from(address).to nil
      end

      it 'sets the association value to the record queried by its `[attribute]` having the value `value` if such record exists.' do
        new_address = Address.create!
        expect { author.address_serial = new_address.serial }.to change(author, :address).from(address).to new_address
      end

      it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.' do
        expect { author.address_serial = address.serial.next }.to raise_exception ActiveRecord::RecordNotFound, "Couldn't find Address"
      end
    end
  end
end
