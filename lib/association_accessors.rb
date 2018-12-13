require "association_accessors/version"
require "association_accessors/singular_association"
require "association_accessors/collection_association"

module AssociationAccessors
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def association_accessor_for(association_name, with_attribute:)
      mixin      = generated_association_methods
      reflection = reflect_on_association association_name

      if reflection.collection?
        CollectionAssociation.define_association_methods mixin, reflection, with_attribute
      else
        SingularAssociation.define_association_methods mixin, reflection, with_attribute
      end
    end
  end
end
