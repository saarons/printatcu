require "net/http"

class UpdateStatuses
  ENDPOINT = "http://www.columbia.edu/acis/facilities/printers/ninja_status.html"

  class << self
    def perform
      uri = URI(ENDPOINT)
      doc = Nokogiri::HTML(Net::HTTP.get(uri))

      results = doc.css("tr:not(:first-child)").inject({}) do |memo, element|
        host = element.children[0].text
        status = element.children[2].text

        color = case status
        when /Ready/
          "green"
        when /Refill/, /Replace/, /Paper/
          "yellow"
        when /Down/, /Unknown/, /Unreachable/, /Service/
          "red"
        end

        memo.merge(host => color)
      end

      $redis.multi
      $redis.del("status")

      $addresses.each_pair do |k, v|
        if (status = results[v])
          $redis.hset("status", k, status)
        end
      end

      $redis.exec

    end

  end
end