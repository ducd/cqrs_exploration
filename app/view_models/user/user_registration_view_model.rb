# frozen_string_literal: true

module User
  class UserRegistrationViewModel
    attr_reader :user, :csrf_token, :errors

    def initialize(user:, csrf_token:, errors: {})
      @user = user
      @csrf_token = csrf_token
      @errors = errors
    end

    def update(**options)
      self.class.new(options)
    end
  end
end
