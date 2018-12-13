module AssociationAccessors
  class SingularAssociation
    def self.define_association_methods mixin, reflection, attribute
      association = reflection.name

      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{association}_#{attribute}
          #{association}&.#{attribute}
        end

        def #{association}_#{attribute}= value
          association_class = association(#{association.inspect}).klass
          send :#{association}=, value && association_class.find_by!(#{attribute}: value)
          value
        end
      CODE
    end
  end
end
