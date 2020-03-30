module EP
  class API
    BASE_URL = 'http://api.estagioemprogramacao.com'

    def self.post(resource, params = {})
      RestClient.post "#{BASE_URL}/#{resource}", params
    end

    def self.get(resource, params = {})
      RestClient.get "#{BASE_URL}/#{resource}", params: params
    end
  end
end
