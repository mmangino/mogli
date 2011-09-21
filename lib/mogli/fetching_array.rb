module Mogli
  class FetchingArray < Array
    attr_accessor :next_url, :previous_url, :client, :classes

    def fetch_next
      return [] if next_url.nil? || next_url.empty?
      additions = client.get_and_map_url(next_url,classes)
      self.next_url = additions.next_url
      self.concat(additions)
      additions
    end

    def fetch_previous
      return [] if previous_url.nil? || previous_url.empty?
      additions = client.get_and_map_url(previous_url,classes)
      self.previous_url = additions.previous_url
      self.unshift(*additions)
      additions
    end
  end
end
