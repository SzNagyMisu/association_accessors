RSpec.describe AssociationAccessors do
  describe 'for polymorphic `belongs_to` association' do
    let!(:author) { Author.create! }
    let!(:image)  { author.create_image! }

    it 'generates `#[association_name]_[attribute_name]` accessor.' do
      expect(image).to respond_to :imageable_serial, :imageable_serial=
    end

    describe '`#[association_name]_[attribute_name]`' do
      it 'returns the value of the `[attribute]` of the associated record if there is any.' do
        expect { image.imageable = nil }.to change(image, :imageable_serial).from(author.serial).to nil
      end
    end

    describe '`#[association_name]_[attribute_name]=(value)`' do
      it 'sets the association value to nil if `value` is nil.' do
        expect { image.imageable_serial = nil }.to change(image, :imageable).from(author).to nil
      end

      it 'sets the association value to the record queried by its `[attribute]` having the value `value` if such record exists.' do
        new_author = Author.create!
        expect { image.imageable_serial = new_author.serial }.to change(image, :imageable).from(author).to new_author
      end

      it 'raises NoMethodError if `[association_name]_type` is not set.' do
        image.imageable = nil
        expect { image.imageable_serial = author.serial }.to raise_exception NoMethodError, %{undefined method `find_by!' for nil:NilClass}
      end

      it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.' do
        expect { image.imageable_serial = author.serial.next }.to raise_exception ActiveRecord::RecordNotFound, "Couldn't find Author"
      end
    end
  end
end
