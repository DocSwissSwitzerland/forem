require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Zurichexpats < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: "https://identity.zurich-expats.ch".freeze,
        authorize_url: "https://identity.zurich-expats.ch/connect/authorize".freeze,
        token_url: "https://identity.zurich-expats.ch/connect/token".freeze,
        scope: "openid email profile".freeze
      }

      def request_phase
        redirectme = { redirect_uri => "https://social.zurich-expats.ch/users/auth/zurichexpats/callback" }
        redirect client.auth_code.authorize_url(redirectme.merge(authorize_params))
      end
    end
  end
end
