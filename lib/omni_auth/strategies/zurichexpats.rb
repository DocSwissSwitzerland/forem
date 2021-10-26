require 'jwt'
require 'date'
require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Zurichexpats < OmniAuth::Strategies::OAuth2


      uid { raw_info["sub"] }

      option :client_options, {
        site: "https://identity.zurich-expats.ch".freeze,
        authorize_url: "https://identity.zurich-expats.ch/connect/authorize".freeze,
        token_url: "https://identity.zurich-expats.ch/connect/token".freeze,
        scope: "openid email profile".freeze
      }


      def request_phase
#        redirectme = { "redirect_uri" => "https://social.zurich-expats.ch/users/auth/zurichexpats/callback" }
        redirect client.auth_code.authorize_url({ "redirect_uri" => "https://social.zurich-expats.ch/users/auth/zurichexpats/callback" }.merge(authorize_params))
      end


      def callback_url
        "#{full_host}#{script_name}#{callback_path}"
      end

      def redirect_url
        "https://social.zurich-expats.ch/users/auth/zurichexpats/callback"
      end

      def raw_info
        date_a = DateTime.now()

        decoded_token = JWT.decode access_token["id_token"], nil, false, { algorithm: 'RS256' }

        decoded_token[0].merge({ "created_at" => "#{date_a}" })

        @raw_info ||= decoded_token[0]
        decoded_token[0]
      end
    end
  end
end
