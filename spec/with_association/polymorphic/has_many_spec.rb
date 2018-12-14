RSpec.describe AssociationAccessors do
  describe 'for polymorphic `has_many` association' do
    let!(:book)    { Book.create! }
    let!(:image_1) { book.images.create! }
    let!(:image_2) { book.images.create! }

    it 'generates `#[association_name.singularize]_[attribute_name.pluralize]` accessor.' do
      expect(book).to respond_to :image_serials, :image_serials=
    end

    describe '`#[association_name.singularize]_[attribute_name.pluralize]`' do
      it 'returns an array with the values of `[attribute]` of the associated records.' do
        expect(book.image_serials).to match_array [ image_1.serial, image_2.serial ]
        expect { book.images = [] }.to change(book, :image_serials).to []
      end
    end

    describe '`#[association_name.singularize]_[attribute_name.pluralize]`=(values)' do
      it 'sets the association value to the records queried by `[attribute]` = `value` if all exist.' do
        expect { book.image_serials = [] }.to change { book.images.ids }.from([ image_1.id, image_2.id ]).to []
        expect { book.image_serials = [ image_1.serial ] }.to change { book.images.ids }.from([]).to [ image_1.id ]
      end

      it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.' do
        expect { book.image_serials = [ image_1.serial, image_2.serial.next ] }
          .to raise_exception(ActiveRecord::RecordNotFound,
                              %{Couldn't find all Images with 'serial': ("#{image_1.serial}", "#{image_2.serial.next}")} +
                              %{ (found 1 results, but was looking for 2). Couldn't find Image with serial "#{image_2.serial.next}".})
      end
    end
  end
end
