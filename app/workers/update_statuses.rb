class UpdateStatuses
  ENDPOINT = "http://www.columbia.edu/acis/facilities/printers/ninja_status.html"

  class << self
    def perform
      response = Excon.get(ENDPOINT)
      doc = Nokogiri::HTML(response.body)

      results = doc.css("tr").inject({}) do |memo, element|
        host = element.children[0].text
        status = element.children[2].text

        color = case status
        when /Ready/
          "green"
        when /Down/, /Unknown/, /Unreachable/, /Service/
          "red"
        else
          "yellow"
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