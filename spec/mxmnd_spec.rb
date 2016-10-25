require "spec_helper"

describe Mxmnd do
  it 'raises BadRequest on missing IP address' do
    expect { Mxmnd::city(nil) }.to raise_error Mxmnd::BadRequest
  end
end
