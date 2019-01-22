RSpec.describe 'for polymorphic `has_one` association' do
  let!(:author) { Author.create! }
  let!(:image)  { author.create_image! }

  it 'generates `#[association_name]_[attribute_name]` accessor.' do
    expect(author).to respond_to :image_serial, :image_serial=
  end

  describe '`#[association_name]_[attribute_name]`' do
    it 'returns the value of the `[attribute]` of the associated record if there is any.' do
      expect { author.image = nil }.to change(author, :image_serial).from(image.serial).to nil
    end
  end

  describe '`#[association_name]_[attribute_name]=(value)`' do
    it 'sets the association value to nil if `value` is nil.' do
      expect { author.image_serial = nil }.to change(author, :image).from(image).to nil
    end

    it 'sets the association value to the record queried by its `[attribute]` having the value `value` if such record exists.' do
      new_image = Image.create!
      expect { author.image_serial = new_image.serial }.to change(author, :image).from(image).to new_image
    end

    it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.', activerecord: [ '4.1' ] do
      expect { author.image_serial = image.serial.next }.to raise_exception ActiveRecord::RecordNotFound
    end

    it 'raises ActiveRecord::RecordNotFound if record with `[attribute]` = `value` does not exist.', activerecord: [ '4.2', '5' ] do
      expect { author.image_serial = image.serial.next }.to raise_exception ActiveRecord::RecordNotFound, "Couldn't find Image"
    end
  end
end
