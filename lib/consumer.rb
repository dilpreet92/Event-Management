Rails.logger.info 'loading file'
module OAuth
  class Consumer
   def token_request(http_method, path, token = nil, request_options = {}, *arguments)
      response = request(http_method, path, token, request_options, *arguments)
      case response.code.to_i

      when (200..299)
        if block_given?
          yield response.body
        else
          # symbolize keys
          # TODO this could be considered unexpected behavior; symbols or not?
          # TODO this also drops subsequent values from multi-valued keys
          CGI.parse(response.body).inject({}) do |h,(k,v)|
            h[k.strip.to_sym] = v.first
            h[k.strip]        = v.first
            h
          end
        end
      when (300..399)
        # this is a redirect
        uri = URI.parse(response.header['location'])
        response.error! if uri.path == path # careful of those infinite redirects
        self.token_request(http_method, uri.path, token, request_options, arguments)
      when (400..499)
        raise 'now this is called'
      else
        response.error!
      end
    end
  end
end