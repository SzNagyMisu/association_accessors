RSpec.describe 'for `has_and_belongs_to_many` association' do
  let!(:author_1)    { Author.create! }
  let!(:author_2)    { Author.create! }
  let!(:publisher_1) { Publisher.create! authors: [ author_1 ] }
  let!(:publisher_2) { Publisher.create! authors: [ author_2 ] }

  it 'generates `#[association_name.singularize]_[attribute_name.pluralize]` accessor.' do
    expect(author_1).to respond_to :publisher_uuids, :publisher_uuids=
  end

  describe '`#[association_name.singularize]_[attribute_name.pluralize]`' do
    it 'returns an array with the values of `[attribute]` of the associated records.' do
      expect(author_1.publisher_uuids).to eq [ publisher_1.uuid ]
      expect(author_2.publisher_uuids).to eq [ publisher_2.uuid ]
    end
  end

  describe '`#[association_name.singularize]_[attribute_name.pluralize]`=(values)' do
    it 'sets the association value to the records queried by `[attribute]` = `value` if all exist.' do
      expect { author_1.publisher_uuids = [] }.to change { author_1.publishers.ids }.from([ publisher_1.id ]).to []
      expect { author_2.publisher_uuids = [ publisher_1.uuid ] }.to change { author_2.publishers.ids }.from([ publisher_2.id ]).to [ publisher_1.id ]
    end

    it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.', activerecord: [ '4' ] do
      expect { author_2.publisher_uuids = [ publisher_1.uuid, publisher_2.uuid.next ] }
        .to raise_exception(ActiveRecord::RecordNotFound,
      %{Couldn't find all Publishers with 'id': ("#{publisher_1.uuid}", "#{publisher_2.uuid.next}")} +
      %{ (found 1 results, but was looking for 2)})
    end

    it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.', activerecord: [ '5.0', '5.1' ] do
      expect { author_2.publisher_uuids = [ publisher_1.uuid, publisher_2.uuid.next ] }
        .to raise_exception(ActiveRecord::RecordNotFound,
      %{Couldn't find all Publishers with 'uuid': ("#{publisher_1.uuid}", "#{publisher_2.uuid.next}")} +
      %{ (found 1 results, but was looking for 2)})
    end

    it 'raises ActiveRecord::RecordNotFound if any of the given `values` has no record.', activerecord: [ '5.2' ] do
      expect { author_2.publisher_uuids = [ publisher_1.uuid, publisher_2.uuid.next ] }
        .to raise_exception(ActiveRecord::RecordNotFound,
      %{Couldn't find all Publishers with 'uuid': ("#{publisher_1.uuid}", "#{publisher_2.uuid.next}")} +
      %{ (found 1 results, but was looking for 2). Couldn't find Publisher with uuid "#{publisher_2.uuid.next}".})
    end
  end
end
