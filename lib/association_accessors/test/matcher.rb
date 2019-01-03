module AssociationAccessors
  module Test
    def have_association_accessor_for association
      Matcher.new association
    end

    class Matcher
      attr_reader :failure_message, :subject, :association_name, :attribute, :association

      def initialize association_name
        @association_name = association_name
      end

      def description
        "have association accessor for #{association_name.inspect} with attribute #{attribute.inspect}."
      end

      def matches? subject
        @subject = subject
        @association = get_association

        check_attribute!

        has_accessors?
      end

      def with_attribute attribute
        @attribute = attribute
        self
      end


      private

        def get_association
          subject.association(association_name)
        end

        def check_attribute!
          raise ArgumentError, "'with_attribute' is required" if attribute.nil?
        end

        def has_accessors?
          accessor_name =
            if association.reflection.collection?
              :"#{association_name.to_s.singularize}_#{attribute.to_s.pluralize}"
            else
              :"#{association_name}_#{attribute}"
            end

          if subject.respond_to?(accessor_name) && subject.respond_to?(:"#{accessor_name}=")
            true
          else
            @failure_message = "reader and/or writer `#{accessor_name}` not defined on #{subject.class.name}."
            false
          end
        end
    end
  end
end
