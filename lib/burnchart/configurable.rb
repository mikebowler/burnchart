module Burnchart

  module Configurable

    # This complicated bit allows us to insert a class method from a mixin, which
    # isn't as straight forward as you might think.
    def self.included base
      base.class_eval do

        # Define a configurable parameter. Possible args are
        # defaults_to: defaultValue
        def self.attr_configurable name, args = {}
          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            def #{name}
              if defined? @#{name}
                @#{name}
              else
                #{args[:defaults_to]}
              end
            end

            def #{name}= arg
              @#{name} = arg
            end
          METHODS

        end
      end
    end
  end
end
