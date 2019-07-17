RSpec.describe 'for `has_many` association' do
  let!(:author_1) { Author.create! }
  let!(:author_2) { Author.create! }
  let!(:book_1)   { Book.create! author: author_1 }
  let!(:book_2)   { Book.create! author: author_1 }

  let!(:kase) { Case.create! }
  let!(:thing) { Thing.create! }

  it 'generates `#[association_name.singularize]_[attribute_name.pluralize]` accessor.' do
    expect(author_1).to respond_to :book_serials, :book_serials=
  end

  describe '`#[association_name.singularize]_[attribute_name.pluralize]`' do
    it 'returns an array with the values of `[attribute]` of the associated records.' do
      expect(author_1.book_serials).to match_array [ book_1.serial, book_2.serial ]
      expect(author_2.book_serials).to eq []
    end
  end

  describe '`#[association_name.singularize]_[attribute_name.pluralize]`=(values)' do
    it 'sets the association value to the records queried by `[attribute]` = `value` if all exist.' do
      expect { author_1.book_serials = [] }.to change { author_1.books.ids }.from([ book_1.id, book_2.id ]).to []
      expect { author_2.book_serials = [ book_1.serial ] }.to change { author_2.books.ids }.from([]).to [ book_1.id ]
      expect { thing.case_serial = kase.serial }.to change { thing.case_id }.from( nil ).to kase.id
    end

    it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.', activerecord: [ '4' ] do
      expect { author_2.book_serials = [ book_1.serial, book_2.serial.next ] }
        .to raise_exception(ActiveRecord::RecordNotFound,
      %{Couldn't find all Books with 'id': ("#{book_1.serial}", "#{book_2.serial.next}")} +
      %{ (found 1 results, but was looking for 2)})
    end

    it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.', activerecord: [ '5.0', '5.1' ] do
      expect { author_2.book_serials = [ book_1.serial, book_2.serial.next ] }
        .to raise_exception(ActiveRecord::RecordNotFound,
      %{Couldn't find all Books with 'serial': ("#{book_1.serial}", "#{book_2.serial.next}")} +
      %{ (found 1 results, but was looking for 2)})
    end

    it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.', activerecord: [ '5.2' ] do
      expect { author_2.book_serials = [ book_1.serial, book_2.serial.next ] }
        .to raise_exception(ActiveRecord::RecordNotFound,
      %{Couldn't find all Books with 'serial': ("#{book_1.serial}", "#{book_2.serial.next}")} +
      %{ (found 1 results, but was looking for 2). Couldn't find Book with serial "#{book_2.serial.next}".})
    end
  end
end
