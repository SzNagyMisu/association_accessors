RSpec.describe AssociationAccessors do
  describe 'for `has_many through:` association' do
    let!(:author_1)  { Author.create! }
    let!(:author_2)  { Author.create! }
    let!(:book_1)    { Book.create! author: author_1 }
    let!(:book_2)    { Book.create! author: author_2 }
    let!(:chapter_1) { Chapter.create! book: book_1 }
    let!(:chapter_2) { Chapter.create! book: book_2 }

    it 'generates `#[association_name.singularize]_[attribute_name.pluralize]` accessor.' do
      expect(author_1).to respond_to :chapter_serials, :chapter_serials=
    end

    describe '`#[association_name.singularize]_[attribute_name.pluralize]`' do
      it 'returns an array with the values of `[attribute]` of the associated records.' do
        expect(author_1.chapter_serials).to eq [ chapter_1.serial ]
        expect(author_2.chapter_serials).to eq [ chapter_2.serial ]
      end
    end

    describe '`#[association_name.singularize]_[attribute_name.pluralize]`=(values)' do
      it 'raises ActiveRecord::HasManyThroughCantAssociateThroughHasOneOrManyReflection.' do
        expect { author_1.chapter_serials = [] }
          .to raise_exception(ActiveRecord::HasManyThroughCantAssociateThroughHasOneOrManyReflection,
                             %{Cannot modify association 'Author#chapters' because the source reflection class 'Chapter' is associated to 'Book' via :has_many.})
      end
    end
  end
end
