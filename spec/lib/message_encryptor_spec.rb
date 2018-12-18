require 'rails_helper'
require 'message_encryptor'

RSpec.describe 'MessageEnryptor' do
  describe 'it can #encrypt and #decrypt data' do
    context 'an array' do
      let(:data) { ['an', 'array', 'of', 'data'] }
      let(:nil_array) { [nil, nil, nil, nil] }

      it 'can encrypt an array' do
        encrypted_data = MessageEncryptor.new(data).encrypt
        expect(MessageEncryptor.new(encrypted_data).decrypt).to eq(data)
      end

      context 'it can #entcrypt and decrypt data with additional parameters set' do
        it 'with a purpose' do
          encrypted_data = MessageEncryptor.new(data, purpose: :rspec).encrypt

          expect(MessageEncryptor.new(encrypted_data, purpose: :rspec).decrypt).to eq(data)
          expect(MessageEncryptor.new(encrypted_data, purpose: :other).decrypt).to eq(nil_array)
        end

        context 'with an expiry date' do
          it 'when the date has not epxpired' do
            encrypted_data = MessageEncryptor.new(data, expires_in: 2.days).encrypt

            expect(MessageEncryptor.new(encrypted_data).decrypt).to eq(data)
          end

          it 'when the date had expired' do
            encrypted_data = MessageEncryptor.new(data, expires_at: 2.days.from_now).encrypt

            Timecop.freeze(4.days.from_now) do
              expect(MessageEncryptor.new(encrypted_data).decrypt).to eq(nil_array)
            end
          end
        end
      end
    end

    context 'a string' do
      let(:data) { 'The quick brown fox' }

      it 'can encrypt a string' do
        data = 'The quick brown fox'
        encrypted_data = MessageEncryptor.new(data).encrypt
        expect(MessageEncryptor.new(encrypted_data).decrypt).to eq(data)
      end

      context 'can encrypt a string with additional parameters' do
        it 'with #purpose set' do
          encrypted_data = MessageEncryptor.new(data, purpose: :rspec).encrypt

          expect(MessageEncryptor.new(encrypted_data, purpose: :rspec).decrypt).to eq(data)
          expect(MessageEncryptor.new(encrypted_data, purpose: :other).decrypt).to eq(nil)
        end

        context 'with #expires_at set' do
          it 'when the date has not epxpired' do
            encrypted_data = MessageEncryptor.new(data, expires_in: 2.days).encrypt

            expect(MessageEncryptor.new(encrypted_data).decrypt).to eq(data)
          end

          it 'when the date had expired' do
            encrypted_data = MessageEncryptor.new(data, expires_at: 2.days.from_now).encrypt

            Timecop.freeze(4.days.from_now) do
              expect(MessageEncryptor.new(encrypted_data).decrypt).to eq(nil)
            end
          end
        end
      end
    end
  end
end
