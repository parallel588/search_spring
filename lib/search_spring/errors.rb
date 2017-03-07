module SearchSpring
  module Errors
    class SearchSpringError < ::StandardError; end
    class NotFound < SearchSpringError; end
    class UnprocessableEntity < SearchSpringError; end
    class InternalServerError < SearchSpringError; end
    class NotAuthorized < SearchSpringError; end
    class AuthenticationError < SearchSpringError; end

    class RequestError < Faraday::Response::Middleware
      def on_complete(env)
        # Ignore any non-error response codes
        return if (status = env[:status]) < 400
        case status
        when 404
          raise Errors::NotFound, response_values(env)
        when 422
          raise Errors::UnprocessableEntity, response_values(env)
        when 401
          raise Errors::NotAuthorized, response_values(env)
        when 407
          # mimic the behavior that we get with proxy requests with HTTPS
          raise Faraday::Error::ConnectionFailed, %{407 "Proxy Authentication Required "}
        when 408...600
          raise Errors::InternalServerError, response_values(env) # Treat any other errors as 500
        end
      end

      def response_values(env)
        { status: env.status, headers: env.response_headers, body: env.body }
      end
    end
  end
end
