RSpec.describe 'for `belongs_to` association' do
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

    it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.', activerecord: [ '4.1' ] do
      expect { book.author_serial = author.serial.next }.to raise_exception ActiveRecord::RecordNotFound
    end

    it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.', activerecord: [ '4.2', '5' ] do
      expect { book.author_serial = author.serial.next }.to raise_exception ActiveRecord::RecordNotFound, "Couldn't find Author"
    end
  end
end
