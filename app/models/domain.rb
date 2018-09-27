class Domain < ApplicationRecord
  attr_accessor :file

  validates_presence_of :domain_name

  def self.check_https_redirect(domain, redirect_count)
    require 'net/http'

    user_agent_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.75 Safari/537.36' # fake Google Chrome 68 on Mac

    puts "Cheking #{domain}"

    begin
      uri = URI.parse("http://#{domain}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = user_agent_string
      response = http.request(request)

      if response.code == '301' or response.code == '302'
        redirect_count = redirect_count + 1

        puts response.code
        uri = URI.parse(response.header['location'])

        if uri.scheme == 'https'

          puts "#{domain}: passed"
          return true
        else
          # check the redirected location
          puts "redirected to #{response.header['location']}"
          if redirect_count < 5
            return check_https_redirect(URI.parse(response.header['location']).host, redirect_count)
          end
        end
      end

      puts "#{domain}: failed"
      return false
    rescue => e
      puts "timedout #{domain}"
      puts "#{domain}: failed"
      return false
    end
  end
end
