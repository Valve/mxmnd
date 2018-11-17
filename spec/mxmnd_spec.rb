require 'spec_helper'

describe Mxmnd do
  it 'raises BadRequest on missing IP address' do
    expect { Mxmnd.city(nil) }.to raise_error Mxmnd::BadRequest
  end
end

describe 'Mxmnd.city response' do
  before {
    @url = 'https://geoip.maxmind.com/geoip/v2.1/city/45.17.22.11'
    response_path = './spec/features/mxmnd_res.txt'
    request_headers = {
      # got from rails hint
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Ruby'
    }
    # i've changed "Content-Length" property of recorded response from 1476 to 2515
    # because of by unknown reason stub didn't return the whole response
    response_file = File.new(response_path)
    stub_request(:get, 'http://https//geoip.maxmind.com/geoip/v2.1/city/45.17.22.11:80/').
      with(headers: request_headers).
      to_return(response_file)
  }

  let(:response) { JSON.parse(Net::HTTP.get(@url, '/')) }

  it 'should be a hash' do
    expect(response).to be_a(Hash)
  end

  it 'should have distinct keys' do
    key_array = [
      'city',
      'continent',
      'country',
      'location',
      'maxmind',
      'postal',
      'registered_country',
      'subdivisions',
      'traits'
    ]
    expect(presence_of_keys?(response, key_array)).to be(true)
  end

  context 'hash' do
    it 'key city should be a hash including 8 locales' do
      expect(response['city']['names'].length).to be 8
    end
    it 'key continent should be a hash including 8 locales' do
      expect(response['continent']['names'].length).to be 8
    end
    it 'key country should be a hash including 8 locales' do
      expect(response['country']['names'].length).to be 8
    end
    it 'key registered_country should be a hash including 8 locales' do
      expect(response['registered_country']['names'].length).to be 8
    end
    it 'key subdivisions should be an array' do
      expect(response['subdivisions']).to be_a(Array)
    end
  end
end
