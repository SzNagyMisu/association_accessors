require 'dummy'

RSpec.describe AssociationAccessors do
  # it "has a version number" do
  #   expect(AssociationAccessors::VERSION).not_to be nil
  # end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end

  describe 'for `belongs_to` association' do
    let!(:author) { Author.create! }
    let!(:book)   { Book.create! author: author }

    it 'generates `#[association_name]_[attribute_name]` accessor.' do
      expect(book).to respond_to :author_serial, :author_serial=
    end

    describe '`#[association_name]_[attribute_name]`' do
      it 'returns the value of the `[attribute]` of the associated record if there is any.' do
        expect { book.author = nil }.to change(book, :author_serial).from(author.serial).to nil
      end
    end

    describe '`#[association_name]_[attribute_name]=(value)`' do
      it 'sets the association value to nil if `value` is nil.' do
        expect { book.author_serial = nil }.to change(book, :author).from(author).to nil
      end

      it 'sets the association value to the record queried by its `[attribute]` having the value `value` if such record exists.' do
        new_author = Author.create!
        expect { book.author_serial = new_author.serial }.to change(book, :author).from(author).to new_author
      end

      it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.' do
        expect { book.author_serial = author.serial.next }.to raise_exception ActiveRecord::RecordNotFound, "Couldn't find Author"
      end
    end
  end

  describe 'for `has_many` association' do
    let!(:author_1) { Author.create! }
    let!(:author_2) { Author.create! }
    let!(:book_1)   { Book.create! author: author_1 }
    let!(:book_2)   { Book.create! author: author_1 }

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
      end

      it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.' do
        expect { author_2.book_serials = [ book_1.serial, book_2.serial.next ] }
          .to raise_exception(ActiveRecord::RecordNotFound,
                              %(Couldn't find all Books with 'serial': ("#{book_1.serial}", "#{book_2.serial.next}")) +
                              %( (found 1 results, but was looking for 2). Couldn't find Book with serial "#{book_2.serial.next}".))
      end
    end
  end
end
