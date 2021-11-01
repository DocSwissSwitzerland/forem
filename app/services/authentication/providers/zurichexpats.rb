require 'httparty'
require 'date'

module Authentication
  module Providers
    class Zurichexpats < Provider
      include HTTParty

      OFFICIAL_NAME = "ZurichExpats".freeze
      SETTINGS_URL = "https://identity.zurich-expats.ch/admin".freeze

      def new_user_data
        date_a = DateTime.now()
        short_username = identity_userinfo.parsed_response["name"].delete(" ")
        short_username = short_username[0 .. 20]

        user_data = {
          email: identity_userinfo.parsed_response["email"],
          zurichexpats_username: identity_userinfo.parsed_response["sub"],
          name: identity_userinfo.parsed_response["name"],
          username: "#{short_username}_#{identity_userinfo.parsed_response["sub"]}".downcase!,
          created_at: date_a
        }

        user_data
      end

      def existing_user_data
        user_data = {
          zurichexpats_username: identity_userinfo.parsed_response["sub"],
        }

        user_data
      end

      def identity_userinfo
        params = { headers: { "Authorization" => "Bearer #{auth_payload.credentials.token}" } }
        self.class.get("https://identity.zurich-expats.ch/connect/userinfo", params)
      end

      def user_nickname
        identity_userinfo.parsed_response["name"]
      end

      def uid
        identity_userinfo.parsed_response["sub"]
      end

      def self.official_name
        OFFICIAL_NAME
      end

      def self.settings_url
        SETTINGS_URL
      end

      def self.sign_in_path(**kwargs)
        ::Authentication::Paths.sign_in_path(
          provider_name,
          **kwargs,
        )
      end

      protected

      def cleanup_payload(auth_payload)
        auth_payload
      end
    end
  end
end
