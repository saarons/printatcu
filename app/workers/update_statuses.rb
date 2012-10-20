require "net/http"

class UpdateStatuses
  ENDPOINT = "http://www.columbia.edu/acis/facilities/printers/ninja_status.html"

  class << self
    def perform
      uri = URI(ENDPOINT)
      doc = Nokogiri::HTML(Net::HTTP.get(uri))

      results = doc.css("td:first-child").inject({}) do |memo, element|
        host = element.children[0].text
        color = case element.attributes["bgcolor"].value
        when "#3ADC1C"
          "green"
        when "#F0F090"
          "yellow"
        when "#C0000"
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