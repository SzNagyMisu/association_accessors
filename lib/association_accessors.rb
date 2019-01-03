require "association_accessors/version"
require "association_accessors/singular_association"
require "association_accessors/collection_association"
require "association_accessors/test/matcher"

module AssociationAccessors
  class << self
    attr_accessor :default_attribute
  end

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def association_accessor_for(association_name, with_attribute: nil)
      mixin      = generated_association_methods
      reflection = reflect_on_association association_name

      with_attribute ||= AssociationAccessors.default_attribute
      raise ArgumentError, 'missing keyword: with_attribute' if with_attribute.nil?

      if reflection.collection?
        CollectionAssociation.define_association_methods mixin, reflection, with_attribute
      else
        SingularAssociation.define_association_methods mixin, reflection, with_attribute
      end
    end
  end
end
