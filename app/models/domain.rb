class Domain < ApplicationRecord
  attr_accessor :file

  validates_presence_of :domain_name

  def self.check_https_redirect(domain, redirect_count)
    require "net/https"

    user_agent_string = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.35 Safari/537.36" # mimic Google Chrome 70 on Mac

    timeout = 10
    puts "Cheking #{domain}"

    begin
      uri = URI.parse("http://#{domain}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = timeout
      http.read_timeout = timeout
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = user_agent_string
      response = http.request(request)

      # check for url redirection
      if response.code == "301" or response.code == "302"
        redirect_count = redirect_count + 1

        puts "Response code: #{response.code}"
        puts "Redirects to: #{response.header['location']}"
        uri = URI.parse(response.header["location"])

        if uri.scheme == "https"
          # check certificate status
          cert = failed_cert_reason = nil

          http = Net::HTTP.new(uri.host, uri.port)
          http.open_timeout = timeout
          http.read_timeout = timeout
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          http.verify_callback = -> (verify_ok, store_context) {
            cert = store_context.current_cert
            failed_cert_reason = [store_context.error, store_context.error_string] if store_context.error != 0
            verify_ok
          }

          begin
            http.start {
            }
            puts "valid certificate"
            return [true, "valid certificate"]
          rescue OpenSSL::SSL::SSLError => e
            error = e.message
            puts "ssl error message: #{error}"
            return [true, error]
          rescue => e
            puts "other error message: #{e.message}"
            return [true, "ssl certificate check failed: #{e.message}"]
          end
        else
          # check the redirected location
          puts "redirected to #{response.header['location']}"
          if redirect_count < 5
            return check_https_redirect(URI.parse(response.header["location"]).host, redirect_count)
          end
        end
      end

      puts "#{domain}: failed"
      return [false, ""]
    rescue => e
      puts "timedout #{domain}"
      puts "#{domain}: failed"
      return [false, ""]
    end
  end
end
