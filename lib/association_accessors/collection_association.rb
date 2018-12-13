module AssociationAccessors
  class CollectionAssociation
    def self.define_association_methods mixin, reflection, attribute
      association = reflection.name
      method_name = "#{association.to_s.singularize}_#{attribute.to_s.pluralize}"

      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{method_name}
          #{association}.map &:#{attribute}
        end

        def #{method_name}= values
          association_class = association(#{association.inspect}).klass
          values = Array(values).reject &:blank?
          records = association_class.where(#{attribute}: values).index_by(&:#{attribute}).values_at(*values).compact
          if records.size == values.size
            send :#{association}=, records
          else
            not_found_values = values - records.map(&:#{attribute})
            association_class.all.raise_record_not_found_exception! values.map(&:inspect), records.size, values.size, :#{attribute}, not_found_values.map(&:inspect)
          end
        end
      CODE
    end
  end
end
