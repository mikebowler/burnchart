module SolvingBits

  module Configurable

    # This complicated bit allows us to insert a class method from a mixin, which
    # isn't as straight forward as you might think.
    def self.included base
      base.class_eval do

        def self.attr_configurable name, args = {}
          instance_var_name = "@#{name}"

          define_method name do
            if instance_variable_defined? instance_var_name
              instance_variable_get instance_var_name
            else
              args[:defaults_to]
            end
          end

          define_method "#{name}=" do |value|
            if args[:only]&.include?(value) == false
              legal_values = args[:only].collect(&:inspect).join(', ')
              raise "Illegal value: #{value.inspect} legal values are #{legal_values}"
            end

            instance_variable_set instance_var_name, value
          end
        end
      end
    end

    def initialize_configuration params: {}, key_prefix: nil, key_description_prefix: nil
      params.each_pair do |key, value|
        key_description = key
        key_description = "#{key_description_prefix}::#{key}" unless key_description_prefix.nil?

        new_key = key
        new_key = "#{key_prefix}_#{key}" unless key_prefix.nil?

        if value.respond_to? :each
          initialize_configuration(
            params: value,
            key_prefix: new_key,
            key_description_prefix: key_description
          )
        else
          method = :"#{new_key}="
          
          if respond_to?(method, true)
            __send__ method, value
          else
            raise "No configuration for #{key_description}"
          end
        end
      end
    end

  end
end
