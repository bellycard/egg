module Egg
  module Dockerfile
    # Provides shared behavior for dockerfile template classes.
    class Base
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

      def run(command, before: [:cmd])
        template.insert(do_before(before), [:run, command])
      end

      def env(env_hash)
        env_string = env_hash.reduce("") do |out, (key, value)|
          out << key.to_s.upcase << '="' << value.to_s << '" '
        end
        template << [:env, env_string]
      end

      private

      def do_before(before)
        template.index(before) ||
          template.index { |tc| tc[0] == before[0] } ||
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
