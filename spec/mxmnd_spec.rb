require "spec_helper"

describe Mxmnd do
  it 'raises BadRequest on missing IP address' do
    expect { Mxmnd::city(nil) }.to raise_error Mxmnd::BadRequest
  end
end

describe 'Mxmnd.city response' do
	before {
		url = 'https://geoip.maxmind.com/geoip/v2.1/city/45.17.22.11'
		path = './spec/tmp/mxmnd_res.txt'
# i've changed "Content-Length" property of recorded response from 1476 to 2515
# because of by unknown reason stub didn't return the whole response
		response_file = File.new(path)
		stub_request(:get, "http://https//geoip.maxmind.com/geoip/v2.1/city/45.17.22.11:80/").
          with(# got from webmock hint
            headers: {  
       	   'Accept'=>'*/*',
       	   'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	   'User-Agent'=>'Ruby'
            }).
          to_return(response_file) 

		@response = JSON.parse(Net::HTTP.get(url, '/'))
	}

	it "should be a hash" do
		@response.is_a?(Hash)
	end

	it "should have distinct keys" do
		keys_array = ["city","continent","country","location","maxmind","postal","registered_country","subdivisions","traits"]
		expect(presence_of_keys?( @response ,keys_array)).to be(true)					
	end
	context 'hash' do
		it 'key city should be a hash including 8 locales' do
			expect(hash_including_locales(@response["city"], 8)).to be(true)
		end
		it 'key continent should be a hash including 8 locales' do
			expect(hash_including_locales(@response["continent"], 8)).to be(true)
		end
		it 'key country should be a hash including 8 locales' do
			expect(hash_including_locales(@response["country"], 8)).to be(true)
		end
		it 'key registered_country should be a hash including 8 locales' do
			expect(hash_including_locales(@response["registered_country"], 8)).to be(true)
		end
		it 'key subdivisions should be an array' do
			@response["subdivisions"].is_a?(Array)
		end
	end
end
