# frozen_string_literal: true

module Customer
  module Commands
    class CreateUserCommand
      attr_reader :params

      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n

          def email?(value)
            !VALID_EMAIL_REGEX.match(value).nil?
          end

          VALID_EMAIL_REGEX =
            /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        end

        required(:name).filled(:str?)
        required(:email).filled(:str?, :email?)
      end

      def initialize(params)
        @params = params
      end

      def validate
        Validator.call(params)
      end
    end
  end
end