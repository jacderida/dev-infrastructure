require 'spec_helper'
describe 'dev_infrastructure' do

  context 'with defaults for all parameters' do
    it { should contain_class('dev_infrastructure') }
  end
end
