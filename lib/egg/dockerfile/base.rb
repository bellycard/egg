module Egg
  module Dockerfile
    # Provides shared behavior for dockerfile template classes.
    class Base
      # Raise when before and after are both used at the same time.
      class QuantumStateError < RuntimeError
        def message
          "Directives cannot happen both before and after a given directive"
        end
      end

      attr_reader :template
      attr_accessor :command

      def initialize
        @template = []
      end

      def required_attributes
        [:command]
      end

      def render
        required_attributes.each do |attr|
          raise(MissingPropertyError, "Must populate #{attr}") if send(attr).nil?
        end

        unrendered_output = compile_unrendered_output

        ERB.new(unrendered_output).result(binding)
      end

      def run(command, before: [:cmd], after: nil)
        insert_with_before_after([:run, command], before: before, after: after)
      end

      def env(env_hash, **before_after)
        env_string = env_hash.reduce("") do |out, (key, value)|
          out << key.to_s.upcase << '="' << value.to_s << '" '
        end
        insert_with_before_after([:env, env_string], before_after)
      end

      def add(localpath, containerpath, **before_after)
        directive = [:add, localpath + " " + containerpath]
        insert_with_before_after(directive, before_after)
      end

      private

      def insert_with_before_after(directive, before: nil, after: nil)
        raise(QuantumStateError) if before && after
        if before
          template.insert(find_directive_in_template(before), directive)
        elsif after
          template.insert(find_directive_in_template(after) + 1, directive)
        else
          template << directive
        end
      end

      def find_directive_in_template(directive)
        template.index(directive) ||
          template.index { |tc| tc[0] == directive[0] } ||
          -1
      end

      def compile_unrendered_output
        final_template = template << [:cmd, "<%= command %>"]
        final_template.reduce("") do |out, (command, string)|
          out << command.to_s.upcase << " " << string << "\n"
        end
      end
    end
  end
end
