require 'rails_helper'

RSpec.describe Speakerphone do
  describe '#notify' do
    let(:audience) { double(:audience) }
    let(:author) { create(:user, name: 'Rick James') }
    let(:article) { create(:article, title: 'Sample Article', author: author) }
    let(:speakerphone) { described_class.new(article, nil, audience) }

    it 'should ping the audience' do
      expect(speakerphone.audience).to receive(:ping).with(
        'New article',
        { icon_emoji: ':book:',
          attachments:
          [ { author_name: 'Rick James',
              title: 'Sample Article',
              title_link: "http://#{ENV['ORIENTATION_DOMAIN']}/articles/sample-article",
              color: 'good'
            }
          ]
        }
      )
      speakerphone.ping_audience(title: 'New article', color: 'good')
    end
  end

  describe '#shout' do
    context 'no Slack config' do
      let(:speakerphone) { described_class.new(nil, nil, slack_config) }
      let(:slack_config) { nil }
      it 'will not shout' do
        expect(speakerphone.shout).to eq(false)
      end

      it 'will log a warning' do
        expect(Rails.logger).to receive(:info)
        speakerphone.shout
      end
    end

    context 'with Slack config' do
      let(:slack_config) { '1234' }
      let(:speakerphone) { described_class.new(article, state, slack_config) }

      context 'in the created state' do
        let(:article) { build(:article) }
        let(:state) { :created }
        it "notifies slack that there is a 'New Article'" do
          expect(speakerphone).to receive(:ping_audience).with(title: 'New article', color: 'good')
          speakerphone.shout
        end
      end

      context 'an archived article' do
        let(:state) { :archived }
        let(:article) { build(:article, archived_at: Time.zone.now) }
        it "notifies slack that it is archived" do
          expect(speakerphone).to receive(:ping_audience).with(title: 'Article archived', color: '#b1b3b4')
          speakerphone.shout
        end
      end

      context 'a rotten article' do
        let(:state) { :rotten }
        let(:article) { build(:article, rotted_at: Time.zone.now) }
        it "notifies slack that it is rotten" do
          expect(speakerphone).to receive(:ping_audience).with(title: 'Article rotten', color: 'danger')
          speakerphone.shout
        end
      end

      context 'an updated article' do
        let(:state) { :updated }
        let(:article) { build(:article) }
        it "notifies slack that it is updated" do
          expect(speakerphone).to receive(:ping_audience).with(title: 'Article updated', color: 'warning')
          speakerphone.shout
        end
      end

      context 'in the destroyed state' do
        let(:article) { build(:article) }
        let(:state) { :destroyed }

        it "notifies slack that it has been destroyed" do
          expect(speakerphone).to receive(:ping_audience).with(title: 'Article destroyed', color: 'danger')
          speakerphone.shout
        end
      end
    end
  end
end




