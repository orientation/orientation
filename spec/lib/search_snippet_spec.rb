require "rails_helper"
require "search_snippet"

RSpec.describe SearchSnippet do
  subject { SearchSnippet.new(query, content) }
  let(:content) do <<-EOS.squish
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat
      duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
      fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
      culpa qui officia deserunt mollit anim id est laborum.
    EOS
  end

  context 'query string matches the first word' do
    let(:query) { 'Lorem' }

    specify { expect(subject.pre_matched_text).to eq('') }
    specify { expect(subject.post_matched_text).to eq(' ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...') }
  end

  context 'query string matches towards the begining of the content' do
    let(:query) { 'ipsum' }

    specify { expect(subject.pre_matched_text).to eq('Lorem ') }
    specify { expect(subject.post_matched_text).to eq(' dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...') }
  end

  context 'query string matches in the middle of the content' do
    let(:query) { 'aute' }

    specify { expect(subject.pre_matched_text).to eq('...exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis ') }
    specify { expect(subject.post_matched_text).to eq(' irure dolor in reprehenderit in voluptate velit esse cillum dolore eu...') }
  end

  context 'query string matches towards the end of the content' do
    let(:query) { 'mollit' }

    specify { expect(subject.pre_matched_text).to eq('...sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt ') }
    specify { expect(subject.post_matched_text).to eq(' anim id est laborum.') }
  end

  context 'query string matches the last word' do
    let(:query) { 'laborum.' }

    specify { expect(subject.pre_matched_text).to eq('...non proident, sunt in culpa qui officia deserunt mollit anim id est ') }
    specify { expect(subject.post_matched_text).to eq('') }
  end

  context 'query string matches partial word' do
    let(:query) { 'rur' }

    specify { expect(subject.pre_matched_text).to eq('...ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute i') }
    specify { expect(subject.post_matched_text).to eq('e dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat...') }
  end

  context 'query string does not match' do
    let(:query) { 'foo' }

    specify { expect(subject.pre_matched_text).to eq('') }
    specify { expect(subject.query).to eq('') }
    specify { expect(subject.post_matched_text).to eq('') }
  end

  context 'query is nil' do
    let(:query) { nil }

    specify { expect(subject.pre_matched_text).to eq('') }
    specify { expect(subject.query).to eq('') }
    specify { expect(subject.post_matched_text).to eq('') }
  end

end
